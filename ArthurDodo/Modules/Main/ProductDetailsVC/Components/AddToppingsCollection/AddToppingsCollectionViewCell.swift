import UIKit

final class AddToppingsCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var toppingImageView = AppImageView(type: .toppings)
    private lazy var titleLabel = AppLabel(type: .topicsTitle)
    private lazy var priceLabel = AppLabel(type: .topicsTitle)
    private lazy var chosenImageView = AppImageView(type: .chosenTopping)

    private lazy var contentStack = AppStackView([toppingImageView, titleLabel, priceLabel], axis: .vertical, spacing: 10, alignment: .center, distribution: .equalSpacing)

    // MARK: - Properties
    private let cornerRadius: CGFloat = 10

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
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        contentView.addSubviews(contentStack, chosenImageView)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            chosenImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chosenImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
}
