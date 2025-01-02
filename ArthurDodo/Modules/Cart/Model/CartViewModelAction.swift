import Foundation

enum CartViewModelAction {
    case dismissButtonTapped
    case emptyCartAction
    case deleteItemTapped(IndexPath)
    case changeCountOfItemsTapped(IndexPath, Int)
    case itemSelected(CartItem)
    case promoSelected(Promo)
    case addNewItemToCartTapped(CartItem)
    case cartButtonTapped
    case updateCart
}
