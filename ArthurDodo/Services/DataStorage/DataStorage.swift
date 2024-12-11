import Foundation

final class DataStorage {

    // MARK: - Module storages
    let profileStorage = ProfileStorage()
    let addressStorage = AddressStorage()
    let cartStorage = CartStorage()

    // MARK: - Properties
    private var fetchedUserAddresses: [Address] = []
    private var fetchedToppings: [Topping] = []
    private var fetchedStories: [Story] = []
    private var fetchedItems: [Item] = []
    private var fetchedUserData: User? // Используется для адресов
    private var category: [Category] = []
    private var order: Order?
    private var specialOfferArray: [Item] = []
    private var selectedItem: SelectedItem?
    private lazy var preferredPaymentMethod: PaymentMethod = .cbp
    private var deliveryTime = ""

    private var changingItem: CartItem?

    // Feature Toggles
    private var localFeatures: [Feature] = []
    private var remoteFeatures: [Feature] = []
    private var features: [FeatureType: Bool] = [:]

    var onLocalFeaturesChanged: (() -> Void)?

    // MARK: - Init
    init() {
        getOrderFromUserDefaults()
    }
}

// MARK: - Special Offers
extension DataStorage {
    // Из всего каталога выбираем кол-во (countOfElements) рандомных элементов
    func getArrayOfRandomItems(_ countOfElements: Int) {
        specialOfferArray = SpecialOffer.configRandomOffer(fetchedItems, countOfElements)
    }

    // Отдает специальные предложения
    func getSpecialOffersArray() -> [Item] {
        specialOfferArray
    }
}


//// MARK: - User data
extension DataStorage {
    // Получаем личные данные
    func setUserData(_ user: User) {
        fetchedUserData = user
    }

    // Отдаем личные данные
    func getUserData() -> User? {
        fetchedUserData
    }

    func getMainAddress() -> Address? {
        return fetchedUserData?.address.first(where: \.isMain)
    }

    // Проверяем были ли ранее загружены данные
    func isUserDataLoaded() -> Bool {
        fetchedUserData != nil
    }

    // Отдаем кол-во додокоинов у юзера
    func getDodoCoins() -> Int {
        fetchedUserData?.dodoCoins ?? 0
    }
}

// MARK: - Stories
extension DataStorage {
    func setStories(_ stories: [Story]) {
        fetchedStories = stories
    }

    func getFetchedStories() -> [Story] {
        fetchedStories
    }
}

// MARK: - Toppings
extension DataStorage {
    // Получаем топпинги
    func setToppings(_ toppings: [Topping]) {
        fetchedToppings = toppings
    }

    // Вытаскиваем допустимые топпинги для продукта
    func getFetchedToppings(for item: Item) -> [Topping]? {
        let itemToppings = item.toppings
        return itemToppings
    }

    // Вытаскиваем допустимые топпинги для позиции в корзине
    func getFetchedToppings(for cartItem: CartItem) -> [Topping]? {
        guard let item = getItem(for: cartItem) else { return nil }
        let itemToppings = item.toppings
        return itemToppings
    }

    func getIngredients(for cartItem: CartItem) -> String? {
        guard let item = getItem(for: cartItem) else { return nil }
        return item.ingredients
    }
}

// MARK: - Catalog
extension DataStorage {
    // Принимаем полученные данные в хранилище
    func setItems(_ items: [Item]) {
        fetchedItems = items.sorted { $0.category.rawValue < $1.category.rawValue }
        getArrayOfRandomItems(5)
        getCategoriesFromCatalog()
    }

    // Отправляет весь каталог товаров
    func getCatalog() -> [Item] {
        fetchedItems
    }

    // Устанавливает выбранный товар, то есть тот, который открыл пользователь
    func sendSelectedItemToStorage(_ item: Item) {
        selectedItem = SelectedItem(item: item)
    }

    // Устанавливает выбранный товар, то есть тот, который открыл пользователь по его ID и тк он идет под редактирование, то устанавливаем ему isChanging: true
    func sendSelectedItemToStorage(with itemId: String) {
        guard let item = fetchedItems.first(where: { $0.id == itemId }) else { return }
        selectedItem = SelectedItem(item: item, isChanging: true)
    }

    // Если есть позиция для редактирования, то возвращает ее, если позиции для редактирования нет, то отправляет выбранный товар
    func getSelectedOrChangingItemFromStorage() -> Item? {
        if changingItem != nil {
            return castChangingItemToItem()
        } else {
            return getSelectedItemFromStorage()
        }
    }

    // Возвращает товар для редактирования, но в виде Item
    func getChangingItem() -> Item? {
        guard let changingItem else { return nil }
        return changingItem.item
    }

    // Возвращает товар для редактирования (в виде CartItem)
    func getChangingCartItem() -> CartItem? {
        changingItem
    }

    // Находит в каталоге позицию для редактирования
    func castChangingItemToItem() -> Item? {
        return getChangingItem()
    }

    // Отправляет выбранный товар, то есть тот, который открыл пользователь
    func getSelectedItemFromStorage() -> Item? {
        selectedItem?.item
    }
}

// MARK: - Categories
extension DataStorage {
    // Формируем список категории (путем обработки каталога, вычленения уникальных категорий и сортировка их в алфавитном порядке)
    func getCategoriesFromCatalog() {
        let set = Set(fetchedItems.compactMap(\.category))
        let sorted = Array(set).sorted { $0.rawValue < $1.rawValue }
        category = sorted
    }

    // Отдаем список категорий
    func getCategories() -> [Category] {
        category
    }
}

// MARK: - Orders
extension DataStorage {
    // Возвращаем общую цену заказа, полученную как сумму перемножения кол-ва единиц на цену
    func getTotalOrderPrice() -> Int {
        guard let order else { print("Order is nil"); return 0 }
        let totalPrice = order.position.compactMap{ $0.price * $0.count }.reduce(0, +)
        return totalPrice
    }

    // Отдаем активный заказ
    func getOrderFromStorage() -> Order? {
        order
    }

    // Получаем заказ из UserDefaults
    private func getOrderFromUserDefaults() {
        order = UserDefaults.standard.getOrder()
    }

    // Принимаем время доставки
    func setDeliveryTime(time: String) {
        deliveryTime = time
    }

    // Формируем заказ (получаем позиции, получаем адрес)
    func configureOrder() {
        guard let orderPositions = castCartToOrder() else { print("OrderPositions is nil"); return }
        guard let address = getMainAddress()?.cityStreetHouse else { print("No main address"); return }
        order = Order(position: orderPositions, deliveryAddress: address, deliveryTime: deliveryTime, status: .inProgress)
    }

    // Делаем заказ из корзины (так как формы заказа и корзины отличаются, то нам нужно скастить корзину до заказа)
    private func castCartToOrder() -> [OrderPosition]? {
        let cart = cartStorage.getCartFromStorage()
        guard let cart else { print("Cart is nil"); return nil}
        var orderPositions: [OrderPosition] = []
        for cartItem in cart.items {
            let position = OrderPosition(itemName: cartItem.item.name, size: cartItem.chosenSize, dough: cartItem.chosenDough, weight: cartItem.weight, price: cartItem.price, count: cartItem.count)
            orderPositions.append(position)
        }
        return orderPositions
    }
}

// MARK: - Preferred payment method
extension DataStorage {
    func getPreferredPaymentMethodFromStorage() -> PaymentMethod {
        getPreferredPaymentMethodFromUserDefaults()
        return preferredPaymentMethod
    }

    private func getPreferredPaymentMethodFromUserDefaults() {
        if let preferredMethod = UserDefaults.standard.getPreferredPaymentMethod() {
            if let tempMethod = PaymentMethod.getMethodFrom(preferredMethod) {
                preferredPaymentMethod = tempMethod
            }
        } else {
//            print("Default payment method = .cbp")
        }
    }
}

// MARK: - Feature toggles
extension DataStorage {
    func getLocalFeatureToggles() -> [Feature] {
        localFeatures
    }

    func getRemoteFeatureToggles() -> [Feature] {
        remoteFeatures
    }

    func setLocalFeatureToggles(_ features: [Feature]) {
        self.localFeatures = features.sorted(by: { $0.name < $1.name })
    }

    func setRemoteFeatureToggles(_ features: [Feature]) {
        self.remoteFeatures = features.sorted(by: { $0.name < $1.name })
    }

    func updateLocalFeatures(_ indexPath: IndexPath, _ status: Bool) {
        localFeatures[indexPath.row].isEnabled = status
        onLocalFeaturesChanged?()
        //        print(localFeatures)
    }

    //  Формируем итоговый словарь, где значение enable будет только в том случае, если у обоих массивов будет значение true
    func setFeaturesArray() {
        let localDict = Dictionary(uniqueKeysWithValues: localFeatures.map { ($0.name, $0.isEnabled) } )
        let remoteDict = Dictionary(uniqueKeysWithValues: remoteFeatures.map { ($0.name, $0.isEnabled) } )

        var appDict: [FeatureType: Bool] = [:]

        for (key, value) in localDict {
            let remoteValue = remoteDict[key]
            let isTrue = (value == true && remoteValue == true)

            if let newKey = FeatureType(rawValue: key) {
                appDict[newKey] = isTrue
            }
        }

        self.features = appDict
        print("features \(features)")
    }

    // Отдаем правильные словарь фичей
    func getFeatures() -> [FeatureType: Bool] {
        features
    }
}

// MARK: - Supporting methods
extension DataStorage {
    func getProductDetails(_ cartItem: CartItem, size: Size) -> WeightPrice? {
        let item = cartItem.item
        let index = size.rawValue

        guard let productDetails = item.itemSize.getWeightAndPriceViaIndex(index) else {print("3. We have some problems here"); return nil }
        return productDetails
    }

    // По cartItem находим Item
    private func getItem(for cartItem: CartItem) -> Item? {
        return cartItem.item
    }
}
