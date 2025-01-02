import Foundation
import Combine

protocol ChoosePaymentMethodVMProtocol {
    func initialize()
    func sendAction(_ action: PaymentMethodViewModelAction)

    var paymentMethodPublisher: Published<PaymentMethod?>.Publisher { get }

    var onPaymentMethodSelected: ((PaymentMethod) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
}
