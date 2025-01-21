import UIKit
import AppUIComponentsSPM

// Ячейка таблицы с товарами в корзине (самая верхняя секция под хэдером)
final class CartProductCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var itemImageView = AppImageView(type: .mediumView)
    private lazy var hitImageView = AppImageView(type: .hit)
    private lazy var titleLabel = AppLabel(type: .basicTitle)
    private lazy var sizeDoughLabel = AppLabel(type: .smallTitle, textColor: AppColors.grayFont)
    private lazy var priceLabel = AppLabel(type: .maxiTitle)
    private lazy var changeLabel = AppLabel(type: .basicTitle, text: "Изменить", textColor: AppColors.buttonOrange)

    private lazy var countStepper = CustomStepperView()

    private lazy var contentStackView = setupContentContainer()

    // MARK: - Properties
    var onValueIsNull: (() -> Void)?
    var onStepperValueChanged: ((Int) -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupStepper()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension CartProductCell {
    func configureCell(cartItem: CartItem) {
        itemImageView.image = UIImage(named: cartItem.item.imageName)
        titleLabel.text = cartItem.item.name

        setProductDetails(cartItem) // Устанавливаем детали продукта
        setPrice(cartItem) // Устанавливаем цену
        isItemHit(cartItem) // Устанавливаем отметку хит
        setCount(cartItem) // Устанавливаем кол-во единиц в степпере
        isCanChange(cartItem) // Показываем или нет лейбл "Изменить"
    }
}

// MARK: - Setup Actions
private extension CartProductCell {
    func setupStepper() {
        countStepper.onValueIsNull = { [weak self] in
            self?.onValueIsNull?()
        }
        countStepper.onStepperValueChanged = { [weak self] value in
            self?.onStepperValueChanged?(value)
        }
    }
}

// MARK: - Setup UI
private extension CartProductCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
        setupElementsLayout()
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints(allInsets: 10)
    }

    func setupElementsLayout() {
        hitImageView.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor).isActive = true
        hitImageView.topAnchor.constraint(equalTo: itemImageView.topAnchor).isActive = true
    }

    func setupContentContainer() -> UIStackView {
        let nameSizeStackView = AppStackView([titleLabel, sizeDoughLabel], axis: .vertical, spacing: 5)
        let imageDetailsStackView = AppStackView([itemImageView, nameSizeStackView], axis: .horizontal, spacing: 10, alignment: .center)
        let countStackView = AppStackView( [changeLabel, countStepper], axis: .horizontal, spacing: 10)
        let priceCountStackView = AppStackView([priceLabel, countStackView], axis: .horizontal)

        let contentStackView = AppStackView([imageDetailsStackView, priceCountStackView], axis: .vertical)

        contentStackView.addSubviews(hitImageView)

        return contentStackView
    }
}

// MARK: - Supporting methods
private extension CartProductCell {
    func setProductDetails(_ cartItem: CartItem) {
        let detailText =
        if cartItem.chosenDough != nil {
            "\(cartItem.chosenSize.displayName), \(cartItem.chosenDough!.displayName)"
        } else {
            "\(cartItem.weight) г"
        }
        sizeDoughLabel.text = detailText
    }

    func setPrice(_ itemInCart: CartItem) {
        let totalPrice = itemInCart.price * itemInCart.count
        priceLabel.text = "\(totalPrice) ₽"
    }

    func setCount(_ item: CartItem) {
        let count = item.count
        countStepper.setStepperValue(count)
    }

    // Если товар Хит, то покажи картинку
    func isItemHit(_ cartItem: CartItem) {
        hitImageView.isHidden =  cartItem.item.isHit ? false : true
    }

    // Если у товара один размер, то прячем кнопку изменить, если несколько, то показываем
    func isCanChange(_ cartItem: CartItem) {
        let isOneSize = cartItem.isOneSize
        changeLabel.isHidden = isOneSize ? true : false
    }
}
