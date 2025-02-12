import UIKit
import AppUIComponentsSPM

// Ячейка раздела Акции в профиле и в корзине
final class PromoCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var promoImageView = DrawView(cornerRadius: .ten, subviewType: .image)

//    AppImageView(type: .radiusCornerView)
    private lazy var nameOfOfferLabel = AppLabel(type: .smallTitle, textColor: AppColors.grayFont)
    private lazy var detailsOfOfferLabel = AppLabel(type: .basicTitle)
    private lazy var dateLabel = AppLabel(type: .smallTitle, textColor: AppColors.grayFont)
    private lazy var applyButton = AppButtons(type: .orangeApplyPromo)

    private lazy var textStack = AppStackView([nameOfOfferLabel, detailsOfOfferLabel, dateLabel, applyButton], axis: .vertical, alignment: .leading, distribution: .equalSpacing)
    private lazy var contentStack = AppStackView([textStack, promoImageView], axis: .horizontal, spacing: 10, distribution: .fillEqually)

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
        configureImageView(with: item)
    }
}

// MARK: - Setup UI
private extension PromoCollectionCell {
    func setupUI() {
        layer.cornerRadius = 14
        clipsToBounds = true
        backgroundColor = AppColors.backgroundGray
        contentView.addSubviews(contentStack)

        configureUIElements()

        setupLayout()
    }

    // Убираем блендинг у UI элементов (это повышает производительность).
    func configureUIElements() {
        [nameOfOfferLabel, detailsOfOfferLabel, dateLabel, promoImageView, textStack, contentStack, contentView].forEach {
            $0.isOpaque = true
            $0.backgroundColor = backgroundColor
        }

        applyButton.isOpaque = true
    }

    // Устанавливаем картинку для imageView (так мы уходим от блендинга в картинке, подробности в классе DrawView)
    func configureImageView(with item: Promo) {
        let image = UIImage(named: item.imageName)
        promoImageView.setImage(image)
    }

    func setupLayout() {
        setupContainerViewLayout()
    }

    func setupContainerViewLayout() {
        contentStack.setConstraints(allInsets: 10)
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
