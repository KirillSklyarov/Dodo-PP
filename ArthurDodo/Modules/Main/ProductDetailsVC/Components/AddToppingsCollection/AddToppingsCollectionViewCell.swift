import UIKit

final class AddToppingsCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private let imageSize: CGFloat = 60
    private let cornerRadius: CGFloat = 10

    // MARK: - UI Properties
    private lazy var toppingImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "tomato")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "cheese"
        label.font = AppFonts.bold14
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "100 ₽"
        label.font = AppFonts.bold14
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    private lazy var chosenImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.isHidden = true
        return imageView
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [toppingImageView, titleLabel, priceLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

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
