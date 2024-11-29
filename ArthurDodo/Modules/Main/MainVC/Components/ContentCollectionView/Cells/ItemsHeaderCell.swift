import UIKit

// Первая большая ячейка в коллекции с товарами
final class ItemsHeaderCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var backView = AppView(type: .roundedTopView)
    private lazy var pizzaImageView = AppImageView(type: .largeView)
    private lazy var titleLabel = AppLabel(type: .orderStatus)
    private lazy var ingredientsLabel = AppLabel(type: .orderTitle)
    private lazy var priceButton = AppButtons(type: .grayPrice)

    private lazy var hitImageView = AppImageView(type: .hit)

    private lazy var contentStack = setupContentStack()

    private var gradientLayer: CAGradientLayer?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backView.layer.cornerRadius = frame.height / 2
        gradientLayer?.frame = bounds
    }

    // MARK: - Public methods
    func configHeader(_ item: Item) {
        let image = UIImage(named: item.imageName)
        pizzaImageView.image = image
        titleLabel.text = item.name
        ingredientsLabel.text = item.ingredients
        priceButton.setPrice(item)
    }
}

// MARK: - Setup UI
private extension ItemsHeaderCell {
    func setupUI() {
        contentView.addSubviews(backView)

        backView.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupBackViewLayout()
        setupContentStackLayout()
    }

    func setupBackViewLayout() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            contentStack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            contentStack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
        ])
    }

    func setupContentStack() -> UIStackView {
        let textStack = AppStackView([titleLabel, ingredientsLabel], axis: .vertical, spacing: 5, alignment: .fill)
        let imageStack = AppStackView([pizzaImageView], axis: .vertical, alignment: .center)
        let textAndImageStack = AppStackView([imageStack, textStack], axis: .vertical)
        let priceStack = AppStackView([UIView(), priceButton], axis: .horizontal)
        let contentStack = AppStackView([textAndImageStack, priceStack], axis: .vertical)
        return contentStack
    }
}

// MARK: - Setup gradient
private extension ItemsHeaderCell {
    func configGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemPurple.cgColor, AppColors.backgroundGray.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        backView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
}
