import UIKit

final class ChoosePaymentMethodVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = CartHeaderView(title: "Оплата") // Заголовок с кнопкой
    private lazy var paymentMethodsTableView = PaymentAddressesTableView(preferredPaymentMethod: preferredPaymentMethod)

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, paymentMethodsTableView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    // MARK: - Other Properties
    private let userDefaults = UserDefaults.standard
    private let storage: DataStorage

    var preferredPaymentMethod: PaymentMethod = .cbp
    var onPaymentMethodSelected: ((PaymentMethod) -> Void)?
    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchPreferredPaymentMethod()
    }
}

// MARK: - Setup UI
private extension ChoosePaymentMethodVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Setup actions
private extension ChoosePaymentMethodVC {
    func setupActions() {
        setupHeaderViewAction()
        setupPaymentMethodsTableAction()
    }

    // Передаем нажатие на закрытие окна
    func setupHeaderViewAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            onDismissButtonTapped?()
        }
    }

    // Получаем выбранный метод оплаты и вызываем замыкание, которое через координатор все передает на нужный экран и это же замыкание в координаторе делаем закрытие окна
    func setupPaymentMethodsTableAction() {
        paymentMethodsTableView.onPaymentMethodTapped = { [weak self]
            paymentMethod in
            guard let self else { return }
            onPaymentMethodSelected?(paymentMethod)
        }
    }
}

// MARK: - Fetch data
private extension ChoosePaymentMethodVC {
    func fetchPreferredPaymentMethod() {
        self.preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
        paymentMethodsTableView.updatePreferredPaymentMethod(preferredPaymentMethod)
    }
}

// MARK: - Supporting methods
private extension ChoosePaymentMethodVC {
    func checkPreferredPaymentMethod() {
        if let preferredPaymentMethod = userDefaults.string(forKey: "preferredPaymentMethod") {
            print("We have a preferred payment method: \(preferredPaymentMethod)")
        } else {
            print("We have NO preferred payment method")
        }
    }
}
