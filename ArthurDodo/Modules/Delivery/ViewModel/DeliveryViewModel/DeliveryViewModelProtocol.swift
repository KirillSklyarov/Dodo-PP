import Foundation
import Combine

protocol DeliveryViewModelProtocol: AnyObject {
    func initialize()
    func sendNewAddressToStorage(_ addressName: String)
    func dismissButtonTapped()
    func addressCellTapped()
    func deliveryTimeSelected(_ time: String)
    func paymentMethodCellTapped()
    func payButtonTapped()

    var mainAddressPublisher: Published<String>.Publisher { get }
    var preferredPaymentMethodPublisher: Published<PaymentMethod>.Publisher { get }
    var cartPricePublisher: Published<Int>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowChooseAddress: (() -> Void)? { get set }
    var onShowChoosePaymentMethod: (() -> Void)? { get set }
    var onShowFinalVC: (() -> Void)? { get set }
}
