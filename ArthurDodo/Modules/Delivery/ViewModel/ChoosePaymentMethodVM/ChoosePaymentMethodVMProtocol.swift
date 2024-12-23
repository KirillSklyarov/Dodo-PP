import Foundation
import Combine

protocol ChoosePaymentMethodVMProtocol {
    func initialize()
    func dismissButtonTapped()
    func paymentMethodSelected(_ paymentMethod: PaymentMethod)

    var paymentMethodPublisher: Published<PaymentMethod?>.Publisher { get }

    var onPaymentMethodSelected: ((PaymentMethod) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
}
