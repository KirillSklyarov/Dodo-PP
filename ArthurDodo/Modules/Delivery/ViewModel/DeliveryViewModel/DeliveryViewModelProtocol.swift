import Combine

protocol DeliveryViewModelProtocol: BasePresenterOutput where ActionType == DeliveryViewModelAction {
   
    var mainAddressPublisher: Published<String?>.Publisher { get }
    var preferredPaymentMethodPublisher: Published<PaymentMethod>.Publisher { get }
    var cartPricePublisher: Published<Int>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowChooseAddress: (() -> Void)? { get set }
    var onShowChoosePaymentMethod: (() -> Void)? { get set }
    var onShowFinalVC: (() -> Void)? { get set }
}
