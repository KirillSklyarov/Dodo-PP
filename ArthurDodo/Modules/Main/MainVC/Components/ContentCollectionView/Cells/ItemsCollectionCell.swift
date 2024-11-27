import UIKit

final class ItemsCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var pizzaImageView = AppImageView(squareSize: imageSize)
    private lazy var titleLabel = AppLabel(textColor: .white, font: .regular(size: 16))
    private lazy var ingredientsLabel = AppLabel(textColor: .grayFont, font: .regular(size: 12))
    private lazy var priceButton = AppPriceGrayButton()
    private lazy var hitImageView = AppImageView(viewImage: .common(.hit), isSystem: false, squareSize: hitImageSize)

    private lazy var detailsStackView = AppStackView( [titleLabel, ingredientsLabel, priceButton], axis: .vertical, spacing: 5, alignment: .leading)

    private lazy var contentStackView = AppStackView([pizzaImageView, detailsStackView], axis: .horizontal, spacing: 10, alignment: .center)

    // MARK: - Properties
    private let imageSize: CGFloat = 130
    private let hitImageSize: CGFloat = 30

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
    func configureCell(_ item: Item) {
        pizzaImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.name
        ingredientsLabel.text = item.ingredients
        priceButton.setPrice(item)
        setHitImage(item)
    }
}

// MARK: - Setup Skeleton
private extension ItemsCollectionCell {
    func setupSkeleton() {
//        isSkeletonable = true
//        contentView.isSkeletonable = true
//        contentStackView.isSkeletonable = true
//        pizzaImageView.isSkeletonable = true
//        titleLabel.isSkeletonable = true
//        ingredientsLabel.isSkeletonable = true
//        priceButton.isSkeletonable = true
//        hitImageView.isSkeletonable = true
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
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
