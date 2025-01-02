import UIKit
import Combine

final class ChoosePaymentMethodVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .payment) // Заголовок с кнопкой
    private lazy var paymentMethodsTableView = PaymentMethodsTableView()

    private lazy var contentStack = AppStackView([headerView, paymentMethodsTableView], axis: .vertical, spacing: 10)

    // MARK: - ViewModel
    private let viewModel: any ChoosePaymentMethodVMProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: any ChoosePaymentMethodVMProtocol) {
        self.viewModel = viewModel
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
        dataBinding()
        viewModel.initialize()
    }
}

// MARK: - ChoosePaymentMethodVCProtocol
extension ChoosePaymentMethodVC: ChoosePaymentMethodVCProtocol {
    func getViewModel() -> any ChoosePaymentMethodVMProtocol {
        viewModel
    }

    func updateUI(_ preferredPaymentMethod: PaymentMethod) {
        paymentMethodsTableView.updatePreferredPaymentMethod(preferredPaymentMethod)
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
        contentStack.setLocalConstraints(isSafeArea: true, top: 0, left: 10, right: 10)
        contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
            viewModel.sendAction(.dismissButtonTapped)
        }
    }

    // Получаем выбранный метод оплаты и вызываем замыкание, которое через координатор все передает на нужный экран и это же замыкание в координаторе делаем закрытие окна
    func setupPaymentMethodsTableAction() {
        paymentMethodsTableView.onPaymentMethodTapped = { [weak self]
            paymentMethod in
            guard let self else { return }
            viewModel.sendAction(.paymentMethodSelected(paymentMethod))
        }
    }
}

// MARK: - Data binding
private extension ChoosePaymentMethodVC {
    func dataBinding() {
        viewModel.paymentMethodPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] paymentMethod in
                guard let self else { return }
                updateUI(paymentMethod)
            }
            .store(in: &cancellables)
    }
}
