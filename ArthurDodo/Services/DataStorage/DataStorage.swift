import Foundation

final class DataStorage {

    // MARK: - Module storages
    let profileStorage = ProfileStorage()
    let addressStorage = AddressStorage()
    let cartStorage = CartStorage()
    lazy var deliveryStorage = DeliveryStorage(storageService: self)
    lazy var mainStorage = MainStorage(storageService: self)

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

// MARK: - Common methods (методы, которые будут использоваться из разных модулей)
extension DataStorage {
    // Мы обнуляем для всех isMain и назначаем для нового, и потом сортируем чтобы isMain был первым
    func setNewMainAddress(_ newMainAddressName: String) {
        guard var fetchedUserData =  profileStorage.getUserData() else { print("fetchedUserData is nil"); return }
        let addresses = fetchedUserData.address
        let newAddresses = addresses.map { address in
            var newAddress = address
            newAddress.isMain = (newAddress.name == newMainAddressName)
            return newAddress
        }
        fetchedUserData.address = newAddresses.sortedMainFirst()
        profileStorage.setUserData(fetchedUserData)
    }

    func getMainAddress() -> Address? {
        return addressStorage.getMainAddress()
    }

    func getTotalOrderPrice() -> Int {
        return cartStorage.getTotalCartPrice()
    }

    func getCart() -> Cart? {
        guard let cart = cartStorage.getCartFromStorage() else { print("Cart is nil"); return nil}
        return cart
    }

    func eraseCart() {
        cartStorage.eraseCart()
    }

    func getAllAddresses() -> [Address] {
        return addressStorage.getAddresses()
    }

    // Отдаем кол-во додокоинов у юзера
    func getDodoCoins() -> Int {
        return profileStorage.getDodoCoins()
    }

    func getOrder() -> Order? {
        return deliveryStorage.getOrderFromStorage()
    }

    func getSpecialOfferArray() -> [Item] {
        return mainStorage.getSpecialOffersArray()
    }

    func setStories(_ stories: [Story]) {
        mainStorage.setStories(stories)
    }

    func setItems(_ items: [Item]) {
        mainStorage.setCatalog(items)
    }

    func addItemToCart(itemToCart: CartItem) {
        cartStorage.addItemToCart(item: itemToCart)
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

//    func getMainAddress() -> Address? {
//        return fetchedUserData?.address.first(where: \.isMain)
//    }

    // Проверяем были ли ранее загружены данные
    func isUserDataLoaded() -> Bool {
        fetchedUserData != nil
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

// MARK: - Orders
extension DataStorage {
    // Возвращаем общую цену заказа, полученную как сумму перемножения кол-ва единиц на цену
//    func getTotalOrderPrice() -> Int {
//        guard let order else { print("Order is nil"); return 0 }
//        let totalPrice = order.position.compactMap{ $0.price * $0.count }.reduce(0, +)
//        return totalPrice
//    }

    // Получаем заказ из UserDefaults
    private func getOrderFromUserDefaults() {
        order = UserDefaults.standard.getOrder()
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
