import UIKit

protocol ChoosePaymentMethodVCInput: BaseViewControllerInput where inputData == PaymentMethod {

}

final class ChoosePaymentMethodVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .payment) // Заголовок с кнопкой
    private lazy var paymentMethodsTableView = PaymentMethodsTableView()

    private lazy var contentStack = AppStackView([headerView, paymentMethodsTableView], axis: .vertical, spacing: 10)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Output
    let output: any ChoosePaymentMethodVCOutput

    // MARK: - Init
    init(output: any ChoosePaymentMethodVCOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - ChoosePaymentMethodVCInput
extension ChoosePaymentMethodVC: ChoosePaymentMethodVCInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        isShowContent(false)
    }

    func configure(with data: PaymentMethod) {
        activityIndicator.stopAnimating()
        updateUI(data)
        isShowContent(true)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Setup UI
private extension ChoosePaymentMethodVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack, activityIndicator)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
        setupActivityIndicatorLayout()
    }

    func setupContentStackLayout() {
        contentStack.setLocalConstraints(isSafeArea: true, top: 0, left: 10, right: 10)
        contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
            output.sendAction(.dismissButtonTapped)
        }
    }

    // Получаем выбранный метод оплаты и вызываем замыкание, которое через координатор все передает на нужный экран и это же замыкание в координаторе делаем закрытие окна
    func setupPaymentMethodsTableAction() {
        paymentMethodsTableView.onPaymentMethodTapped = { [weak self]
            paymentMethod in
            guard let self else { return }
            output.sendAction(.paymentMethodSelected(paymentMethod))
        }
    }
}

// MARK: - Supporting methods
private extension ChoosePaymentMethodVC {
    func updateUI(_ preferredPaymentMethod: PaymentMethod) {
        paymentMethodsTableView.updatePreferredPaymentMethod(preferredPaymentMethod)
    }

    func isShowContent(_ bool: Bool) {
        contentStack.alpha = bool ? 1 : 0
    }
}

