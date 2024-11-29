import UIKit

// Коллекция "Вам понравится" на главном экране
final class SpecialOfferCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var itemImageView = AppImageView(type: .justView)
    private lazy var titleLabel = AppLabel(type: .name)
    private lazy var priceLabel = AppLabel(type: .dodoCoinsSubtitle)

    private lazy var contentStack = setupContentStack()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ item: Item) {
        itemImageView.image = UIImage(named: item.imageName)
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

            itemImageView.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.4)
        ])
    }

    func setupContentStack() -> UIStackView {
        let textStack = AppStackView([titleLabel, priceLabel], axis: .vertical, spacing: 5, alignment: .leading)
        let contentStack = AppStackView( [itemImageView, textStack], axis: .horizontal, spacing: 10, alignment: .center)
        return contentStack
    }
}
