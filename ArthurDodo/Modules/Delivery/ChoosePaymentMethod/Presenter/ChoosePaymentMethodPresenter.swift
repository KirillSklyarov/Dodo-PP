import Foundation

protocol ChoosePaymentMethodVCOutput: BaseViewControllerOutput where ActionType == PaymentMethodViewModelAction {

    var coordinatorEventHandler: ((PaymentMethodCoordinatorEvent) -> Void)? { get set }
}

enum PaymentMethodViewModelAction {
    case dismissButtonTapped
    case paymentMethodSelected(PaymentMethod)
}

final class ChoosePaymentMethodPresenter {

    // MARK: - Properties
    var paymentMethodData: PaymentMethod?
    var coordinatorEventHandler: ((PaymentMethodCoordinatorEvent) -> Void)?

    private let userDefaults = UserDefaults.standard
    private let storage: DeliveryStorage

    weak var view: (any ChoosePaymentMethodVCInput)?

    // MARK: - Init
    init(storage: DeliveryStorage) {
        self.storage = storage
    }
}

// MARK: - ChoosePaymentMethodVCOutput
extension ChoosePaymentMethodPresenter: ChoosePaymentMethodVCOutput {
    // Когда получаем сигнал, что view загрузилась, то выставляем ей стартовое положение и начинаем загружать данные
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        view?.showLoading()
        fetchData()
    }

    // Проверяем, если с данными все ок, то обновляем view, если нет - то показываем алёрт с ошибкой
    func checkDataAndUpdateView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            isDataValid() ? updateView() : setErrorState()
        }
    }

    // Обрабатываем действия пользователя
    func sendAction(_ action: PaymentMethodViewModelAction) {
        switch action {
        case .dismissButtonTapped: dismissButtonTapped()
        case .paymentMethodSelected(let paymentMethod): paymentMethodSelected(paymentMethod)
        }
    }
}

// MARK: - Fetch data
private extension ChoosePaymentMethodPresenter {
    // Забираем предпочитаемый метод оплаты из хранилища
    func fetchData() {
        paymentMethodData = storage.getPreferredPaymentMethodFromStorage()
    }
}

// MARK: - Supporting methods
private extension ChoosePaymentMethodPresenter {
    func isDataValid() -> Bool {
        return paymentMethodData != nil
    }

    func updateView() {
        guard let paymentMethodData else { return }
        view?.configure(with: paymentMethodData)
    }

    func setErrorState() {
        coordinatorEventHandler?(.showPaymentMethodErrorAlertModule)
        view?.showError()
    }

    func dismissButtonTapped() {
        coordinatorEventHandler?(.dismissModule)
    }

    // Когда выбран способ оплаты, то отправляем эти данные в UserDefaults и отрабатываем замыкание
    func paymentMethodSelected(_ paymentMethod: PaymentMethod) {
        setPreferredPaymentMethodToUserDefaults(paymentMethod)
        coordinatorEventHandler?(.paymentMethodSelected(paymentMethod))
    }

    // Сохраняем выбранный способ оплаты в UserDefaults
    func setPreferredPaymentMethodToUserDefaults(_ paymentMethod: PaymentMethod) {
        userDefaults.setPreferredPaymentMethod(paymentMethod)
    }
}
