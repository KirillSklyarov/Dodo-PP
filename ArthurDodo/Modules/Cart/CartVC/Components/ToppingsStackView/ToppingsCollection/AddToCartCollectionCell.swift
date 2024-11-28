import UIKit

// Ячейка раздела "Добавить в корзину" корзины
final class AddToCartCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var detailsBackgroundView = AppViewDS(type: .details)
    private lazy var itemImageView = AppImageView(height: imageSize)
    private lazy var titleLabel = AppLabelDS(type: .promoCellTitle)
    private lazy var detailsLabel = AppLabelDS(type: .itemSubtitle)
    private lazy var priceLabel = AppLabelDS(type: .priceGrayLabel)

    private lazy var contentStack = setupContentStack()

    // MARK: - Properties
    private let imageSize: CGFloat = 100
    private let cornerRadius: CGFloat = 10
    private let leftInset: CGFloat = 5
    private let rightInset: CGFloat = -5
    private let topInset: CGFloat = 5
    private let bottomInset: CGFloat = -5

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configCell(_ itemToAdd: Item) {
        itemImageView.image = UIImage(named: itemToAdd.imageName)
        titleLabel.text = itemToAdd.name
        setProductDetails(itemToAdd)
        setPrice(itemToAdd)
    }
}

// MARK: - Supporting methods
private extension AddToCartCollectionCell {
    func setProductDetails(_ item: Item) {
        let dough = item.getCorrectDough()
        let size = item.getCorrectSize().displayName
        let weight = item.getCorrectWeight()
        if let dough {
            detailsLabel.text = "\(size), \(dough)"
        } else {
            detailsLabel.text = "\(weight) г"
        }
    }

    func setPrice(_ item: Item) {
        let price = item.getCorrectPrice()
        let title = "\(price) ₽"
        priceLabel.text = title
    }
}

// MARK: - Setup UI
private extension AddToCartCollectionCell {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        contentView.addSubviews(detailsBackgroundView, contentStack)

        setupLayout()
    }

    // Настраиваем контент стек
    func setupContentStack() -> UIStackView {
        // Группируем в стек текстовые лейблы элементы
        let textStack = AppStackView([titleLabel, detailsLabel], axis: .vertical, spacing: 5)

        // Делаем так, чтобы название и детали всегда были по верхнему краю
        let topTextStack = AppStackView([textStack], axis: .horizontal, alignment: .top)

        // Всё группируем в общий стек
        let contentStack = AppStackView([itemImageView, topTextStack, priceLabel], axis: .vertical, spacing: 5)

        return contentStack
    }

    func setupLayout() {
        setupContentStackLayout()
        setupBackgroundViewLayout()
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset),
        ])
    }

    func setupBackgroundViewLayout() {
        NSLayoutConstraint.activate([
            detailsBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailsBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailsBackgroundView.topAnchor.constraint(equalTo: itemImageView.centerYAnchor)
        ])
    }
}
