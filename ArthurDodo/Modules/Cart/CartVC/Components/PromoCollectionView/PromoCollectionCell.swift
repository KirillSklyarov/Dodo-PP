import UIKit

final class PromoCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10

    // MARK: - UI Properties
    private lazy var promoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var nameOfOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold14
        label.textColor = AppColors.grayFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var detailsOfOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold16
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular14
        label.textColor = AppColors.grayFont
        label.textAlignment = .left
        return label
    }()
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        let title = "Применить"
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: AppFonts.bold14])
        )
        config.baseForegroundColor = .white
        config.baseBackgroundColor = AppColors.buttonOrange
        config.cornerStyle = .capsule
        button.configuration = config
        button.isUserInteractionEnabled = false
        return button
    }()

    private lazy var textStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameOfOfferLabel, detailsOfOfferLabel, dateLabel, applyButton])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStack, promoImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ item: Promo) {
        nameOfOfferLabel.text = item.name.uppercased()
        detailsOfOfferLabel.text = item.details
        dateLabel.text = item.date
        let image = UIImage(named: item.imageName)
        promoImageView.image = image
    }
}

// MARK: - Setup UI
private extension PromoCollectionCell {
    func setupUI() {
        layer.cornerRadius = 14
        clipsToBounds = true
        backgroundColor = AppColors.backgroundGray
        contentView.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupContainerViewLayout()
    }

    func setupContainerViewLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset)
        ])
    }
}
