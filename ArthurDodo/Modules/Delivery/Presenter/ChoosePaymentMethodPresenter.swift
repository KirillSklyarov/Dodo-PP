import Foundation

protocol ChoosePaymentMethodPresenterProtocol: AnyObject {
    func viewDidLoad()
    func dismissButtonTapped()
    func paymentMethodSelected(_ paymentMethod: PaymentMethod)

    var onPaymentMethodSelected: ((PaymentMethod) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
}

final class ChoosePaymentMethodPresenter {
    weak var view: ChoosePaymentMethodVCProtocol?

    // MARK: - Other Properties
    private let userDefaults = UserDefaults.standard
    private let storage: DeliveryStorage

    var preferredPaymentMethod: PaymentMethod = .cbp
    var onPaymentMethodSelected: ((PaymentMethod) -> Void)?
    var onDismissButtonTapped: (() -> Void)?

    init(storage: DeliveryStorage) {
        self.storage = storage
    }
}

// MARK: - ChoosePaymentMethodPresenterProtocol
extension ChoosePaymentMethodPresenter: ChoosePaymentMethodPresenterProtocol {
    func viewDidLoad() {
        fetchPreferredPaymentMethod()
    }

    func dismissButtonTapped() {
        onDismissButtonTapped?()
    }

    func paymentMethodSelected(_ paymentMethod: PaymentMethod) {
        onPaymentMethodSelected?(paymentMethod)
    }
}

// MARK: - Fetch data
private extension ChoosePaymentMethodPresenter {
    func fetchPreferredPaymentMethod() {
        self.preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
        view?.updateUI(preferredPaymentMethod)
    }
}

// MARK: - Supporting methods
private extension ChoosePaymentMethodPresenter {
    func checkPreferredPaymentMethod() {
        if let preferredPaymentMethod = userDefaults.string(forKey: "preferredPaymentMethod") {
            print("We have a preferred payment method: \(preferredPaymentMethod)")
        } else {
            print("We have NO preferred payment method")
        }
    }
}
