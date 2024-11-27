import UIKit

// Горизонтальная коллекция в профиле с додокоинами, заказами и адресами
final class CoinsOrdersCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private let coinsImageSize: CGFloat = 70
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let cornerRadius: CGFloat = 14

    // MARK: - UI Properties
    private lazy var iconImageView = AppImageView(squareSize: coinsImageSize)

    private lazy var containerImageView: UIView = {
        let view = UIView()
        view.addSubviews(iconImageView)
        return view
    }()
    private lazy var titleLabel = AppLabel(textColor: .white, font: .bold(size: 40))

    private lazy var subTitleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .white.withAlphaComponent(0.2)
        config.cornerStyle = .capsule
        button.configuration = config
        return button
    }()
    private lazy var contentStackView = AppStackView([containerImageView, titleLabel, subTitleButton], axis: .vertical, spacing: 10, alignment: .leading)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ indexPath: IndexPath, data: User) {
        let data = data
        let item = indexPath.item

        switch item {
        case 0: designDodoCoinsCell(data)
        case 1: designOrdersCell(data)
        case 2: designAddressCell(data)
        default: break
        }
    }
}

// MARK: - Design Coins Cell
private extension CoinsOrdersCollectionViewCell {
    // Отрисовываем ячейку с додокоинами
    func designDodoCoinsCell(_ data: User) {
        designCoinsImage()
        designCoinsLabel(data)
        setButtonTitle("додокоины")
    }

    // Устанавливаем картинку
    func designCoinsImage() {
        contentView.backgroundColor = AppColors.dodoCoinsBlue
        let image = UIImage(named: "dodoCoinsImage")
        iconImageView.image = image
    }

    // Настраиваем лейбл
    func designCoinsLabel(_ data: User) {
        let dodoCoins = data.dodoCoins.description
        titleLabel.text = dodoCoins
    }
}

// MARK: - Design Orders Cell
private extension CoinsOrdersCollectionViewCell {
    // Отрисовываем ячейку с заказами
    func designOrdersCell(_ data: User) {
        designOrderImage()
        designOrderLabel()
        designOrderButton(data)
    }

    // Устанавливаем картинку
    func designOrderImage() {
        contentView.backgroundColor = AppColors.backgroundGray
        let image = UIImage(named: "dodoCoinsImage")
        iconImageView.image = image
    }

    // Настраиваем лейбл
    func designOrderLabel() {
        titleLabel.text = "Mои заказы"
        titleLabel.font = AppFonts.bold22
    }

    // Настраиваем кнопку с заказами
    func designOrderButton(_ data: User) {
        let countOfOrders = data.orders
        let title = "заказ".pluralize(for: countOfOrders)
        setButtonTitle("\(countOfOrders) \(title)")
    }
}

// MARK: - Design Address Cell
private extension CoinsOrdersCollectionViewCell {
    // Отрисовываем ячейку с адресами
    func designAddressCell(_ data: User) {
        setImage()
        setTitle()
        setAddressTitle(data)
    }

    // Устанавливаем картинку
    func setImage() {
        let image = UIImage(named: "mapPin")
        iconImageView.image = image
    }

    // Устанавливаем лейбл
    func setTitle() {
        titleLabel.text = "Адреса доставки"
        titleLabel.numberOfLines = 0
        titleLabel.font = AppFonts.bold22
    }

    // Устанавливаем адреса
    func setAddressTitle(_ data: User) {
        let countOfAddress = data.address.count
        let addressWord = "адрес".pluralize(for: countOfAddress)
        let title = "\(countOfAddress) \(addressWord)"
        setButtonTitle(title)
    }

    func setButtonTitle(_ title: String) {
        subTitleButton.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold14])
        )
    }
}

// MARK: - Setup UI
private extension CoinsOrdersCollectionViewCell {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        contentView.backgroundColor = AppColors.backgroundGray

        contentView.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContainerViewLayout()
        setupContainerImageViewLayout()
    }

    func setupContainerViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset),
        ])
    }

    func setupContainerImageViewLayout() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: containerImageView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: containerImageView.leadingAnchor)
        ])
    }
}
