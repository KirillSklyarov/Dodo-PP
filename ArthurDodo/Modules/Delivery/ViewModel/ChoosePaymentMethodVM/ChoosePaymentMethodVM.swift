import Foundation
import Combine

enum PaymentMethodViewModelAction {
    case dismissButtonTapped
    case paymentMethodSelected(PaymentMethod)
}

final class ChoosePaymentMethodVM {

    // MARK: - Properties
    @Published var preferredPaymentMethod: PaymentMethod?

    var paymentMethodPublisher: Published<PaymentMethod?>.Publisher { $preferredPaymentMethod }

    var onPaymentMethodSelected: ((PaymentMethod) -> Void)?
    var onDismissButtonTapped: (() -> Void)?

    private let userDefaults = UserDefaults.standard
    private let storage: DeliveryStorage

    // MARK: - Init
    init(storage: DeliveryStorage) {
        self.storage = storage
    }
}

// MARK: - ChoosePaymentMethodPresenterProtocol
extension ChoosePaymentMethodVM: ChoosePaymentMethodVMProtocol {
    func loadData() {
        fetchData()
    }

    func sendAction(_ action: PaymentMethodViewModelAction) {
        switch action {
        case .dismissButtonTapped: dismissButtonTapped()
        case .paymentMethodSelected(let paymentMethod): paymentMethodSelected(paymentMethod)
        }
    }
}

// MARK: - Supporting methods
private extension ChoosePaymentMethodVM {
    // Забираем предпочитаемый метод оплаты из хранилища
    func fetchData() {
        preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
    }

    func dismissButtonTapped() {
        onDismissButtonTapped?()
    }

    // Когда выбран способ оплаты, то отправляем эти данные в UserDefaults и отрабатываем замыкание
    func paymentMethodSelected(_ paymentMethod: PaymentMethod) {
        setPreferredPaymentMethodToUserDefaults(paymentMethod)
        onPaymentMethodSelected?(paymentMethod)
    }

    // Сохраняем выбранный способ оплаты в UserDefaults
    func setPreferredPaymentMethodToUserDefaults(_ paymentMethod: PaymentMethod) {
        userDefaults.setPreferredPaymentMethod(paymentMethod)
    }
}
