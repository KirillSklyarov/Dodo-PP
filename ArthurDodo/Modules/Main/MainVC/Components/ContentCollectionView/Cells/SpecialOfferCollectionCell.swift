import UIKit

final class SpecialOfferCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var pizzaImageView = AppImageView(squareSize: imageViewSize)
    private lazy var titleLabel = AppLabelDS(type: .name)
    private lazy var priceLabel = AppLabelDS(type: .dodoCoinsSubtitle)
    private lazy var textStack = AppStackView([titleLabel, priceLabel], axis: .vertical, spacing: 5, alignment: .leading)
    private lazy var contentStack = AppStackView( [pizzaImageView, textStack], axis: .horizontal, spacing: 10, alignment: .center)

    // MARK: - Properties
    private let imageViewSize: CGFloat = 90

    var onPriceButtonTapped: ( (String) -> Void )?

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
        priceLabel.setPrice(item)
    }
}

// MARK: - Setup UI
private extension SpecialOfferCollectionCell {
    func setupUI() {
        contentView.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: - Setup Skeleton
private extension SpecialOfferCollectionCell {
    func setupSkeleton() {
//        isSkeletonable = true
    }
}
