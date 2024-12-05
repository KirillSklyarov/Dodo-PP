import UIKit

final class AddToppingsCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var toppingImageView = AppImageView(type: .toppings)
    private lazy var titleLabel = AppLabel(type: .smallTitle)
    private lazy var priceLabel = AppLabel(type: .smallTitle)
    private lazy var chosenImageView = AppImageView(type: .chosenTopping)

    private lazy var contentStack = AppStackView([toppingImageView, titleLabel, priceLabel], axis: .vertical, spacing: 10, alignment: .center, distribution: .equalSpacing)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension AddToppingsCollectionViewCell {
    func configCell(_ topping: Topping) {
        toppingImageView.image = UIImage(named: topping.imageName)
        titleLabel.text = topping.name.rawValue
        priceLabel.text = "\(topping.price) ₽"
    }

    func chooseTopping() {
        backgroundColor = .darkGray.withAlphaComponent(0.3)
        chosenImageView.isHidden = false
    }

    func hideTopping() {
        backgroundColor = .clear
        chosenImageView.isHidden = true
    }

    func getChosenToppingPrice() -> Int {
        let price = priceLabel.text?.components(separatedBy: " ").first ?? "0"
        return Int(String(price)) ?? 0
    }
}

// MARK: - Setup UI
private extension AddToppingsCollectionViewCell {
    func setupUI() {
        setupUIElements()
        layer.cornerRadius = 10
        layer.masksToBounds = true

        contentView.addSubviews(contentStack, chosenImageView)

        setupLayout()
    }

    func setupUIElements() {
        [titleLabel, priceLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }
    }

    func setupLayout() {
        contentStack.setConstraints()
        chosenImageView.setLocalConstraints(top: 0, right: -5)
    }
}
