import Foundation

final class CartStorage {
    private var fetchedPromo: [Promo] = []
    private var specialOfferArray: [Item] = []
    private var cart: Cart?
    private var changingItem: CartItem?
    private var selectedPromo: Promo?
}

// MARK: - Methods
extension CartStorage {
    // Если корзина еще пустая (cart=nil), то создаем корзину с этим продуктов, если не пустая, то либо добавляем продукт в корзину, либо меняем на отредактированный товар
    func addItemToCart(item: CartItem) {
        if cart == nil {
            cart = Cart(items: [item])
        } else {
            changeOrAddItemToCart(item: item)
        }
    }

    // Устанавливаем продукт для редактирования
    func setChangingItem(_ item: CartItem) {
        changingItem = item
    }

    func changeItemInCart(_ item: CartItem) {
        guard let index = cart?.items.firstIndex(where: { $0 == changingItem } ) else { print("No item found"); return }
        cart?.items[index] = item
        self.changingItem = nil
    }

    func getCartFromStorage() -> Cart? {
        guard let cart else { print("Cart is nil"); return nil }
        return cart
    }

    // Мы возвращаем цену только в том случае,
    func getTotalCartPrice() -> Int {
        guard let cart else { return 0 }
        return cart.items.compactMap{ $0.price * $0.count }.reduce(0, +)
    }

    // Изменяем кол-во позиций в корзине
    func changeCountOfItems(_ indexPath: IndexPath, _ value: Int) {
        cart?.items[indexPath.row].count = value
    }

    // Удаляем позицию из корзины
    func removeItemFromCart(_ indexPath: IndexPath) {
        cart?.items.remove(at: indexPath.row)
    }

    // Возвращаем кол-во товаров в корзине (например, в корзине 2 маргариты и 1 сок - ответ: 3)
    func getCountOfItemsInCart() -> Int {
        guard let cart else { print("Cart is nil"); return 0 }
        return cart.items.compactMap{ $0.count }.reduce(0, +)
    }

    // Обнуляем корзину
    func eraseCart() {
        cart = nil
    }

    func getProductDetails(_ cartItem: CartItem, size: Size) -> WeightPrice? {
        let item = cartItem.item
        let index = size.rawValue

        guard let productDetails = item.itemSize.getWeightAndPriceViaIndex(index) else { print("3. We have some problems here"); return nil }
        return productDetails
    }

    func getCorrectWeight(_ cartItem: CartItem, _ size: Size) -> Int {
        guard let productDetails = getProductDetails(cartItem, size: size) else { print("4. We have some problems here"); return 0 }
        return productDetails.weight
    }

    func getCorrectPrice(_ cartItem: CartItem, _ size: Size) -> Int {
        guard let productDetails = getProductDetails(cartItem, size: size) else { print("5. We have some problems here"); return 0 }
        return productDetails.price
    }

    // Возвращает товар для редактирования (в виде CartItem)
    func getChangingCartItem() -> CartItem? {
        changingItem
    }

    // Вытаскиваем допустимые топпинги для позиции в корзине
    func getFetchedToppings(for cartItem: CartItem) -> [Topping]? {
        let item = cartItem.item
        let itemToppings = item.toppings
        return itemToppings
    }
}

// MARK: - Promo
extension CartStorage: PromoStorageProtocol {
    // Получаем промо (коллекция "Акции" в корзине и в профиле)
    func setPromo(_ promo: [Promo]) {
        fetchedPromo = promo
    }

    // Возвращает загруженные акции
    func getPromo() -> [Promo] {
        fetchedPromo
    }

    func setSelectedPromo(_ promo: Promo) {
        selectedPromo = promo
    }

    func getSelectedPromo() -> Promo? {
        selectedPromo
    }
}

private extension CartStorage {
    // Если продукт для редактирования есть, то находим его индекс в заказе и подменяем его на исправленный товар
    func changeOrAddItemToCart(item: CartItem) {
        if let changingItem {
            guard let index = cart?.items.firstIndex(where: { $0 == changingItem } ) else { print("No item found"); return }
            cart?.items[index] = item
            self.changingItem = nil
        } else {
            cart?.items.append(item)
        }
    }
}
