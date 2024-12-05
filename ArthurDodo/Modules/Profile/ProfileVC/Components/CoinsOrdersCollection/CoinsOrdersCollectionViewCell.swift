import UIKit

// Горизонтальная коллекция в профиле с додокоинами, заказами и адресами
final class CoinsOrdersCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var iconImageView = AppImageView(type: .dodoCoinsLarge)
    private lazy var titleLabel = AppLabel(type: .maxiHeader)
    private lazy var subTitleLabel = AppLabel(type: .priceGrayRoundLabel)

    private lazy var contentStackView = AppStackView([iconImageView, titleLabel, subTitleLabel], axis: .vertical, spacing: 10, alignment: .leading)

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
        setSubTitleText("додокоины")
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
        setSubTitleText("\(countOfOrders) \(title)")
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
        setSubTitleText(title)
    }

    func setSubTitleText(_ title: String) {
        subTitleLabel.text = title.uppercased()
    }
}

// MARK: - Setup UI
private extension CoinsOrdersCollectionViewCell {
    func setupUI() {
        layer.cornerRadius = 14
        clipsToBounds = true
        contentView.backgroundColor = AppColors.backgroundGray

        contentView.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContainerViewLayout()
    }

    func setupContainerViewLayout() {
        contentStackView.setConstraints(allInsets: 10)
    }
}
