import Foundation
import Combine

protocol ChoosePaymentMethodVMProtocol: BasePresenterOutput where ActionType == PaymentMethodViewModelAction {

    var paymentMethodPublisher: Published<PaymentMethod?>.Publisher { get }

    var onPaymentMethodSelected: ((PaymentMethod) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
}
