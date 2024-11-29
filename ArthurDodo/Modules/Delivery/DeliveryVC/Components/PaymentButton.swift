import UIKit

// Кнопка "Оплатить" на экране "Доставка", которая меняет дизайн в зависимости от выбранного способа оплаты
final class PaymentButtonView: UIView {

    // MARK: - UI Properties
    private lazy var paymentTitleLabel = AppLabel(type: .legalTitle)
    private lazy var paymentImageView = AppImageView(type: .payment, image: preferredPaymentMethod?.image)
    private lazy var paymentMethodLabel = AppLabel(type: .legalTitle, text: preferredPaymentMethod?.title, textColor: AppColors.backgroundBlack)

    private lazy var paymentStack = AppStackView([paymentImageView, paymentMethodLabel], axis: .horizontal, spacing: 5)

    private lazy var contentStack = setupContentStack()

    // MARK: - Properties
    private let buttonHeight: CGFloat = 50
    private let cornerRadius: CGFloat = 20
    private let imageSize: CGFloat = 24

    private var preferredPaymentMethod: PaymentMethod?

    var onPayButtonTapped: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, _ preferredPaymentMethod: PaymentMethod) {
        super.init(frame: frame)
        self.preferredPaymentMethod = preferredPaymentMethod
        setupUI()
        setupLayout()
        setupTap()
        updateUI(with: preferredPaymentMethod)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension PaymentButtonView {
    func updateUI(with paymentMethod: PaymentMethod?) {
        self.preferredPaymentMethod = paymentMethod

        switch preferredPaymentMethod {
        case .card, .cash: designCardAndCashMethodsButton()
        case .cbp: designCBPMethodsButton()
        case .sberPay: designSberPayMethodsButton()
        case .none: break
        }
    }
}

// MARK: - Supporting methods
private extension PaymentButtonView {
    func designCardAndCashMethodsButton() {
        backgroundColor = AppColors.buttonOrange
        paymentTitleLabel.text = "Оформить заказ"
        paymentTitleLabel.textColor = .white
        paymentMethodLabel.text = ""
        paymentImageView.image = nil
        paymentStack.isHidden = true
    }

    func designCBPMethodsButton() {
        backgroundColor = .white
        paymentTitleLabel.text = "Оплатить"
        paymentTitleLabel.textColor = AppColors.backgroundBlack
        paymentMethodLabel.text = preferredPaymentMethod?.title
        paymentImageView.image = preferredPaymentMethod?.image
        paymentImageView.contentMode = .scaleAspectFit
        paymentStack.isHidden = false
    }

    func designSberPayMethodsButton() {
        backgroundColor = AppColors.sberGreen
        paymentTitleLabel.text = ""
        paymentTitleLabel.textColor = AppColors.backgroundBlack
        paymentMethodLabel.text = ""
        paymentImageView.image = UIImage(named: "sber")
        paymentImageView.contentMode = .scaleAspectFill
        paymentStack.isHidden = false
    }
}

// MARK: - Setup UI
private extension PaymentButtonView {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        setupContentStackLayout()
    }

    func setupContentStackLayout() {
        contentStack.setConstraints()
    }

    func setupContentStack() -> UIStackView {
        let preContentStack = AppStackView([paymentTitleLabel, paymentStack], axis: .horizontal, spacing: 10)
        let contentStack = AppStackView([preContentStack], axis: .vertical, alignment: .center)
        return contentStack
    }
}

// MARK: - Setup tapGesture
private extension PaymentButtonView {
    func setupTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cartButtonTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc func cartButtonTapped() {
        onPayButtonTapped?()
    }
}
