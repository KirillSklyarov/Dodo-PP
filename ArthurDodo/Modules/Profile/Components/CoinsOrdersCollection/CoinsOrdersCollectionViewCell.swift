import UIKit
import SkeletonView

final class CoinsOrdersCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "CoinsOrdersCollectionViewCell"
    private let coinsImageSize: CGFloat = 70
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let cornerRadius: CGFloat = 14

    // MARK: - UI Properties
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: coinsImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: coinsImageSize).isActive = true
        return imageView
    }()
    private lazy var containerImageView: UIView = {
        let view = UIView()
        view.addSubviews(iconImageView)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold40
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    private lazy var subTitleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .white.withAlphaComponent(0.2)
        config.cornerStyle = .capsule
        button.configuration = config
        return button
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [containerImageView, titleLabel, subTitleButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSkeleton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ indexPath: IndexPath, data: Personal) {
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

// MARK: - Supporting methods
private extension CoinsOrdersCollectionViewCell {
    func designDodoCoinsCell(_ data: Personal) {
        contentView.backgroundColor = AppColors.dodoCoinsBlue
        let image = UIImage(named: "dodoCoinsImage")
        iconImageView.image = image
        let dodoCoins = data.dodoCoins.description
        titleLabel.text = dodoCoins
        setButtonTitle("додокоины")
    }

    func designOrdersCell(_ data: Personal) {
        let image = UIImage(named: "dodoCoinsImage")
        iconImageView.image = image
        titleLabel.text = "Mои заказы"
        titleLabel.font = AppFonts.bold22
        let countOfOrders = data.orders
        let title = "заказ".pluralize(for: countOfOrders)
        setButtonTitle("\(countOfOrders) \(title)")
    }

    func designAddressCell(_ data: Personal) {
        let image = UIImage(named: "mapPin")
        iconImageView.image = image
        titleLabel.text = "Адреса доставки"
        titleLabel.numberOfLines = 0
        titleLabel.font = AppFonts.bold22
        let countOfAddress = data.address.count.description
        setButtonTitle("\(countOfAddress) адрес")
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

// MARK: - Setup Skeleton
private extension CoinsOrdersCollectionViewCell {
    func setupSkeleton() {
        isSkeletonable = true
    }
}
