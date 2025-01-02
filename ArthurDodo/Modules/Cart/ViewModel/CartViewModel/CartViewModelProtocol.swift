import Foundation
import Combine

protocol CartViewModelProtocol: BaseViewModelProtocol where ActionType == CartViewModelAction {

    var promoPublisher: Published<[Promo]?>.Publisher { get }
    var itemsToAddPublisher: Published<[Item]?>.Publisher { get }
    var cartPublisher: Published<Cart?>.Publisher { get }
    var countAndTotalPublishers: Publishers.CombineLatest<Published<Int?>.Publisher, Published<Int?>.Publisher> { get }

    var onCartVCDismissed: (() -> Void)? { get set }
    var onShowEditProductVC: (() -> Void)? { get set }
    var onShowPromoVC: (() -> Void)? { get set }
    var onShowDeliveryVC: (() -> Void)? { get set }
}
