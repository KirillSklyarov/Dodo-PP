import UIKit

final class ItemsCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var pizzaImageView = AppImageView(type: .justView)
    private lazy var titleLabel = AppLabel(type: .basicTitle)
    private lazy var ingredientsLabel = AppLabel(type: .smallTitle, textColor: AppColors.grayFont)
    private lazy var priceButton = AppButtons(type: .grayPrice)
    private lazy var hitImageView = AppImageView(type: .hit)

    private lazy var contentStackView = setupContentStackView()

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
    func configureCell(_ item: Item) {
        pizzaImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.name
        ingredientsLabel.text = item.ingredients
        priceButton.setPrice(item)
        setHitImage(item)
    }
}

// MARK: - Setup UI
private extension ItemsCollectionCell {
    func setupUI() {
        contentView.addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        contentStackView.setConstraints(insets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        pizzaImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.4).isActive = true
    }

    func setupContentStackView() -> UIStackView {
        let detailsStackView = AppStackView([titleLabel, ingredientsLabel, priceButton], axis: .vertical, spacing: 5, alignment: .leading, distribution: .equalSpacing)

        setupUIComponentsPriorities()

        let contentStackView = AppStackView([pizzaImageView, detailsStackView], axis: .horizontal, spacing: 10, alignment: .center)


        return contentStackView
    }

    // Устанавливаем приоритеты сжатия, чтобы AutoLayout знал, кого можно сжимать а кого нет
    func setupUIComponentsPriorities() {
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        ingredientsLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        priceButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}

// MARK: - Setup actions
private extension ItemsCollectionCell {
    func setupActions() {
        priceButton.onButtonTapped = { // [weak self] in
            print(#function)
        }
    }
}

// MARK: - Supporting methods
private extension ItemsCollectionCell {
    func setHitImage(_ item: Item) {
        if item.isHit {
            hitImageView.isHidden = false
        } else {
            hitImageView.isHidden = true
        }
    }
}
