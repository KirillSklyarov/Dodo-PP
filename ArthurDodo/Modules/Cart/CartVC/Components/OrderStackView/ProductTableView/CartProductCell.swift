import UIKit

// Ячейка таблицы с товарами в корзине (самая верхняя секция под хэдером)
final class CartProductCell: UITableViewCell {

    // MARK: - Properties
    static let identifier: String = "CartProductCell"
    private let imageSize: CGFloat = 100
    private let hitImageSize: CGFloat = 30

    var onValueIsNull: (() -> Void)?
    var onStepperValueChanged: ((Int) -> Void)?
    var onChangeButtonTapped: ( () -> Void)?

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
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
    private lazy var changeNumbersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить", for: .normal)
        button.setTitleColor(AppColors.buttonOrange, for: .normal)
        button.titleLabel?.font = AppFonts.semibold16
        button.addTarget(self, action: #selector (changeButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var countStepper = CustomStepperView()
    private lazy var contentContainer = UIView()

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
    func configureCell(itemInCart: CartItem) {
        pizzaImageView.image = UIImage(named: itemInCart.imageName)
        titleLabel.text = itemInCart.name

        setProductDetails(itemInCart) // Текст с тестом, размером или весом
        setPrice(itemInCart)
        isItemHit(itemInCart)
        let count = itemInCart.count
        countStepper.setStepperValue(count)
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

    @objc func changeButtonTapped(_ sender: UIButton) {
        onChangeButtonTapped?()
    }
}

// MARK: - Setup UI
private extension CartProductCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        setupContentContainer()

        contentView.addSubviews(contentContainer)
        setupContentContainerLayout()
    }

    func setupContentContainer() {
        let nameSizeStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, sizeDoughLabel])
            stack.axis = .vertical
            stack.spacing = 5
            return stack
        }()

        let countStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [changeNumbersButton, countStepper])
            stack.axis = .horizontal
            stack.spacing = 10
            return stack
        }()

        contentContainer.addSubviews(pizzaImageView, hitImageView, nameSizeStackView, priceLabel, countStackView)

        NSLayoutConstraint.activate([
            pizzaImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            pizzaImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 10),

            hitImageView.trailingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor),
            hitImageView.topAnchor.constraint(equalTo: pizzaImageView.topAnchor),

            nameSizeStackView.centerYAnchor.constraint(equalTo: pizzaImageView.centerYAnchor),
            nameSizeStackView.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor, constant: 10),
            nameSizeStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -10),

            priceLabel.topAnchor.constraint(equalTo: pizzaImageView.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: pizzaImageView.leadingAnchor),

            countStackView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            countStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -10),
        ])
    }

    func setupContentContainerLayout() {
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func isItemHit(_ item: CartItem) {
        if item.isHit {
            hitImageView.isHidden = false
        } else {
            hitImageView.isHidden = true
        }
    }
}

// MARK: - Supporting methods
private extension CartProductCell {
    func setProductDetails(_ itemInCart: CartItem) {
        let detailText =
        if itemInCart.dough != nil {
            "\(itemInCart.size.displayName), \(itemInCart.dough!.rawValue)"
        } else {
            "\(itemInCart.weight) г"
        }
        sizeDoughLabel.text = detailText
    }

    func setPrice(_ itemInCart: CartItem) {
        let totalPrice = itemInCart.price * itemInCart.count
        priceLabel.text = "\(totalPrice) ₽"
    }
}
