import UIKit

final class PaymentButtonView: UIView {

    // MARK: - UI Properties
    private lazy var payContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var paymentTitleLabel = AppLabel(textColor: .backgroundBlack, font: .bold(size: 20))

    private lazy var paymentMethodLabel = AppLabel(text: preferredPaymentMethod?.title, textColor: .backgroundBlack, font: .bold(size: 20))

    private lazy var paymentImageView: UIImageView = {
        let imageView = UIImageView()
        let image = preferredPaymentMethod?.image
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()

    private lazy var paymentStack = AppStackView([paymentImageView, paymentMethodLabel], axis: .horizontal, spacing: 5)
    private lazy var contentStack = AppStackView([paymentTitleLabel, paymentStack], axis: .horizontal, spacing: 10)

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
        payContainerView.backgroundColor = AppColors.buttonOrange
        paymentTitleLabel.text = "Оформить заказ"
        paymentTitleLabel.textColor = .white
        paymentMethodLabel.text = ""
        paymentImageView.image = nil
        paymentStack.isHidden = true
    }

    func designCBPMethodsButton() {
        payContainerView.backgroundColor = .white
        paymentTitleLabel.text = "Оплатить"
        paymentTitleLabel.textColor = AppColors.backgroundBlack
        paymentMethodLabel.text = preferredPaymentMethod?.title
        paymentImageView.image = preferredPaymentMethod?.image
        paymentImageView.contentMode = .scaleAspectFit
        paymentStack.isHidden = false
    }

    func designSberPayMethodsButton() {
        payContainerView.backgroundColor = AppColors.sberGreen
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
        addSubviews(payContainerView)
        payContainerView.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        setupPayContainerView()
        setupContentStack()

        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }

    func setupContentStack() {
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: payContainerView.centerXAnchor),
            contentStack.topAnchor.constraint(equalTo: payContainerView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: payContainerView.bottomAnchor),
        ])
    }

    func setupPayContainerView() {
        NSLayoutConstraint.activate([
            payContainerView.topAnchor.constraint(equalTo: topAnchor),
            payContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            payContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            payContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
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
