import UIKit

// Ячейка таблицы с товарами в корзине (самая верхняя секция под хэдером)
final class CartProductCell: UITableViewCell {

    // MARK: - Properties
    private let imageSize: CGFloat = 100
    private let hitImageSize: CGFloat = 30

    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10

    var onValueIsNull: (() -> Void)?
    var onStepperValueChanged: ((Int) -> Void)?

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var hitImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "hit2")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.isHidden = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular18
        label.numberOfLines = 0
        return label
    }()
    private lazy var sizeDoughLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = AppFonts.regular14
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.bold20
        return label
    }()
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.text = "Изменить"
        label.textColor = AppColors.buttonOrange
        label.font = AppFonts.semibold16
        return label
    }()
    private lazy var countStepper = CustomStepperView()

    private lazy var contentStackView = setupContentContainer()

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
        pizzaImageView.image = UIImage(named: cartItem.item.imageName)
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
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset),
        ])
    }

    func setupElementsLayout() {
        NSLayoutConstraint.activate([
            hitImageView.trailingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor),
            hitImageView.topAnchor.constraint(equalTo: pizzaImageView.topAnchor),
        ])
    }

    func setupContentContainer() -> UIStackView {
        let nameSizeStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, sizeDoughLabel])
            stack.axis = .vertical
            stack.spacing = 5
            return stack
        }()

        let imageDetailsStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [pizzaImageView, nameSizeStackView])
            stack.axis = .horizontal
            stack.spacing = 10
            stack.alignment = .center
            return stack
        }()

        let countStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [changeLabel, countStepper])
            stack.axis = .horizontal
            stack.spacing = 10
            return stack
        }()

        let priceCountStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [priceLabel, countStackView])
            stack.axis = .horizontal
            return stack
        }()

        let contentStackView = {
            let stack = UIStackView(arrangedSubviews: [imageDetailsStackView, priceCountStackView])
            stack.axis = .vertical
            return stack
        }()

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
