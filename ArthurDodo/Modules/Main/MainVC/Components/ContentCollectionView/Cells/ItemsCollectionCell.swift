import UIKit

final class ItemsCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var pizzaImageView = AppImageViewDS(type: .justView)
    private lazy var titleLabel = AppLabelDS(type: .name)
    private lazy var ingredientsLabel = AppLabelDS(type: .itemSubtitle)
    private lazy var priceButton = AppButtonsDS(type: .grayPrice)
    private lazy var hitImageView = AppImageViewDS(type: .hit)

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
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            pizzaImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.4),
        ])
    }

    func setupContentStackView() -> UIStackView {
        let detailsStackView = AppStackView( [titleLabel, ingredientsLabel, priceButton], axis: .vertical, spacing: 5, alignment: .leading)

        let contentStackView = AppStackView([pizzaImageView, detailsStackView], axis: .horizontal, spacing: 10, alignment: .center)
        return contentStackView
    }
}

// MARK: - Setup actions
private extension ItemsCollectionCell {
    func setupActions() {
        priceButton.onButtonTapped = { [weak self] in
            print("Button tapped")
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
