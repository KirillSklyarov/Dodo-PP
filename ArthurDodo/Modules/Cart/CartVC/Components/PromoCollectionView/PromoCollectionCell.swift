import UIKit

// Ячейка раздела Акции в профиле и в корзине
final class PromoCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var promoImageView = AppImageView(type: .radiusCornerView)
    private lazy var nameOfOfferLabel = AppLabel(type: .orderTitle)
    private lazy var detailsOfOfferLabel = AppLabel(type: .name)
    private lazy var dateLabel = AppLabel(type: .orderTitle)
    private lazy var applyButton = AppButtons(type: .orangeApplyPromo)

    private lazy var textStack = AppStackView( [nameOfOfferLabel, detailsOfOfferLabel, dateLabel, applyButton], axis: .vertical, alignment: .leading, distribution: .equalSpacing)
    private lazy var contentStack = AppStackView([textStack, promoImageView], axis: .horizontal, spacing: 10, distribution: .fillEqually)

    // MARK: - Properties
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
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

// MARK: - Setup Action
private extension PromoCollectionCell {
    func setupActions() {
        setupApplyButtonAction()
    }

    func setupApplyButtonAction() {
        applyButton.onButtonTapped = { // [weak self] in
            print("Apply button tapped")
        }
    }
}
