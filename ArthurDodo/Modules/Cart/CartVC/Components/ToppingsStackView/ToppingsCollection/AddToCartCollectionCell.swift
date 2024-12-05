import UIKit

// Ячейка раздела "Добавить к заказу" корзины
final class AddToCartCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var detailsBackgroundView = AppView(type: .details)
    private lazy var itemImageView = AppImageView(type: .justView)
    private lazy var titleLabel = AppLabel(type: .basicTitle)
    private lazy var detailsLabel = AppLabel(type: .smallTitle, textColor: AppColors.grayFont)
    private lazy var priceLabel = AppLabel(type: .priceGrayRoundLabel)

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
        setupUIElements()

        layer.cornerRadius = 10
        layer.masksToBounds = true

        contentView.addSubviews(detailsBackgroundView, contentStack)

        setupLayout()
    }

    func setupUIElements() {
        titleLabel.numberOfLines = 3
        titleLabel.adjustsFontSizeToFitWidth = true
        detailsLabel.adjustsFontSizeToFitWidth = true
        detailsLabel.numberOfLines = 2
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
        contentStack.setConstraints(allInsets: 5)
        itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor).isActive = true
    }

    func setupBackgroundViewLayout() {
        detailsBackgroundView.setLocalConstraints(bottom: 0, left: 0, right: 0)
        detailsBackgroundView.topAnchor.constraint(equalTo: itemImageView.centerYAnchor).isActive = true
    }
}
