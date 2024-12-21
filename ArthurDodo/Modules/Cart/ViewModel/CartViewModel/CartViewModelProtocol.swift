import Foundation
import Combine

protocol CartViewModelProtocol: AnyObject {
    func initialize()
    func updateCart() 
    func cartVCDismissed()
    func cartIsEmpty()
    func deleteItemFromCart(_ indexPath: IndexPath)
    func changeCountOfItem(_ indexPath: IndexPath, _ count: Int)
    func selectItem(_ item: CartItem)
    func promoSelected(_ promo: Promo)
    func addNewItemToCartTapped(_ item: CartItem)
    func cartButtonTapped()

    var promoPublisher: Published<[Promo]?>.Publisher { get }
    var itemsToAddPublisher: Published<[Item]?>.Publisher { get }
    var cartPublisher: Published<Cart?>.Publisher { get }
    var countAndTotalPublishers: Publishers.CombineLatest<Published<Int?>.Publisher, Published<Int?>.Publisher> { get }

    var onCartVCDismissed: (() -> Void)? { get set }
    var onShowEditProductVC: (() -> Void)? { get set }
    var onShowPromoVC: ((Promo) -> Void)? { get set }
    var onShowDeliveryVC: (() -> Void)? { get set }
}
