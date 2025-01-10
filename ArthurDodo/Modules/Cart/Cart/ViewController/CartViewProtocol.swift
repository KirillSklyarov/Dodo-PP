import Foundation

protocol CartViewProtocol: AnyObject {
    func getViewModel() -> CartViewModelProtocol
    func setState(_ state: ScreenState)
    func updateUI(_ countOfItems: Int?, _ totalPrice: Int?)
    func promoCollectionUpdateUI(_ promo: [Promo]?)
    func updateCart(_ cart: Cart?)
    func updateItemsToAdd(_ items: [Item]?)
}
