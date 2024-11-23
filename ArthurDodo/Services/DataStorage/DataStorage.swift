import Foundation

final class DataStorage {

    // MARK: - Properties
    private var fetchedUserAddresses: [Address] = []
    private var fetchedToppings: [Topping] = []
    private var fetchedStories: [Story] = []
    private var fetchedItems: [Item] = []
    private var fetchedPromo: [Promo] = []
    private var fetchedUserData: User?
    private var category: [Category] = []
    private var order: Order?
    private var cart: Cart?
    private var specialOfferArray: [Item] = []
    private var selectedItem: SelectedItem?
    private lazy var preferredPaymentMethod: PaymentMethod = .cbp
    private var deliveryTime = ""

    private var changingItem: CartItem?

    private let networkManager: NetworkManager

    // MARK: - Callbacks
    var onDataFetchedSuccessfully: (() -> Void)?
    var onToppingsFetchedSuccessfully: (([Topping]) -> Void)?
    var onStoriesFetchedSuccessfully: (([Story]) -> Void)?
    var onItemsFetchedSuccessfully: (() -> Void)?
    var onPromoFetchedSuccessfully: (([Promo]) -> Void)?
    var onUserDataFetchedSuccessfully: ((User) -> Void)?

    var onError: ((Error) -> Void)?

    // MARK: - Init
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        getOrderFromUserDefaults()
    }
}

// MARK: - Cart
extension DataStorage {
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

    // Если продукт для редактирования есть, то находим его индекс в заказе и подменяем его на исправленный товар
    private func changeOrAddItemToCart(item: CartItem) {
        if let changingItem {
            guard let index = cart?.items.firstIndex(where: { $0 == changingItem } ) else { print("No item found"); return }
            cart?.items[index] = item
            self.changingItem = nil
        } else {
            cart?.items.append(item)
        }
    }

    func changeItemInCart(_ item: CartItem) {
        guard let index = cart?.items.firstIndex(where: { $0 == changingItem } ) else { print("No item found"); return }
        cart?.items[index] = item
        self.changingItem = nil
    }

    func getCartFromStorage() -> Cart? {
        guard let cart else { print("1.Cart is nil"); return nil }
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
}

// MARK: - Personal
extension DataStorage {
    // Фетчим личные данные
    func fetchUserData() {
        networkManager.fetchData(.personal) { [weak self] (result: Result<User, NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let personalData):
                fetchedUserData = personalData
                onUserDataFetchedSuccessfully?(personalData)
            case .failure(let error):
                onError?(error)
                print(error)
            }
        }
    }

    func getDodoCoins() -> Int {
        guard let fetchedUserData else { return 0 }
        return fetchedUserData.dodoCoins
    }

    // Отдаем личные данные
    func getPersonalData() -> User? {
        fetchedUserData
    }

    // Проверяем были ли ранее загружены данные
    func isUserDataLoaded() -> Bool {
        fetchedUserData != nil
    }
}

// MARK: - User Addresses
extension DataStorage {

    // Запрашиваем из сети данные по адреса конкретного юзера по ID (сейчас для теста просто взяли "1")
    func fetchUserAddresses() {
        networkManager.fetchAddressesWithID("1") { [weak self] (result: Result<[Address], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let address):
                fetchedUserAddresses = address
                onDataFetchedSuccessfully?()
            case .failure(let error):
                print(error)
            }
        }
    }

    // Отправляем новый адрес на сервер и выводим сообщение о результате
    func sendNewAddressToServer(addressToEdit: Address) {
        networkManager.updateUserAddress(addressToEdit) { (result: Result<Address, NetworkError>) in
            switch result {
            case .success(let address):
                print("Данные успешно обновлены: \(address)")
            case .failure(let error):
                print("Данные НЕ обновлены: \(error)")
            }
        }
    }

    // Если данные юзера еще не были запрошены (то есть fetchedUserData == nil), то возвращаем true, в противном случае возвращаем false
    func isAddressesEmpty() -> Bool {
        return fetchedUserData == nil ? true : false
    }

    func getMainAddress() -> Address? {
        fetchedUserData?.address.first(where: \.isMain)
    }

    func getAddresses() -> [Address] {
        guard let fetchedUserData else { print("fetchedUserData is nil"); return [] }
        return fetchedUserData.address
    }

    // Мы обнуляем для всех isMain и назначаем для нового, и потом сортируем чтобы isMain был первым
    func setNewMainAddress(_ newMainAddressName: String) {
        guard let fetchedUserData else { print("fetchedUserData is nil"); return }
        let addresses = fetchedUserData.address
        let newAddresses = addresses.map { address in
            var newAddress = address
            newAddress.isMain = (newAddress.name == newMainAddressName)
            return newAddress
        }
        self.fetchedUserData?.address = newAddresses.sortedMainFirst()
    }

    // Получаем кол-во адресов у юзера
    func getCountOfAddresses() -> Int {
        guard let fetchedUserData else { return 0 }
        return fetchedUserData.address.count
    }

    // Добавляем адрес в список адресов (но только в хранилище)
    func addAddress(_ address: Address) {
        self.fetchedUserData?.address.append(address)
    }
}

// MARK: - Stories
extension DataStorage {
    func fetchStories() {
        networkManager.fetchData(.stories) { [weak self] (result: Result<[Story], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let stories):
                fetchedStories = stories
                onStoriesFetchedSuccessfully?(fetchedStories)
            case .failure(let error):
                print(error)
            }
        }
    }

    func getFetchedStories() -> [Story] {
        fetchedStories
    }
}

// MARK: - Toppings
extension DataStorage {
    func fetchToppings() {
        networkManager.fetchData(.toppings) { [weak self] (result: Result<[Topping], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let topping):
                fetchedToppings = topping
                onToppingsFetchedSuccessfully?(fetchedToppings)
            case .failure(let error):
                print(error)
            }
        }
    }

    func getFetchedToppings(for item: Item) -> [Topping]? {
        let itemToppings = item.toppings
        return itemToppings
    }

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

// MARK: - Items
extension DataStorage {
    func fetchItems() {
        networkManager.fetchData(.products) { [weak self] (result: Result<[Item], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let items):
                fetchedItems = items.sorted { $0.category.rawValue < $1.category.rawValue }
                getArrayOfRandomItems(5)
                getCategoriesFromCatalog()
                onItemsFetchedSuccessfully?()
            case .failure(let error):
                print(error)
            }
        }
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

// MARK: - Promo
extension DataStorage {
    func fetchPromo() {
        networkManager.fetchData(.promo) { [weak self] (result: Result<[Promo], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let promo):
                fetchedPromo = promo
                onPromoFetchedSuccessfully?(fetchedPromo)
            case .failure(let error):
                print(error)
            }
        }
    }

    // Показывает были ли ранее загружены акции
    func isPromoAlreadyFetched() -> Bool {
        !fetchedPromo.isEmpty
    }

    // Возвращает загруженные акции 
    func getPromoFromStorage() -> [Promo] {
        fetchedPromo
    }
}

// MARK: - Categories
extension DataStorage {
    func getCategoriesFromCatalog() {
        let set = Set(fetchedItems.compactMap(\.category))
        let sorted = Array(set).sorted { $0.rawValue < $1.rawValue }
        category = sorted
    }

    func getCategories() -> [Category] {
        category
    }
}

// MARK: - Orders
extension DataStorage {
    // Мы возвращаем цену только в том случае,
    func getTotalOrderPrice() -> Int {
        guard let order else { print("Order is nil"); return 0 }
        return order.position.compactMap{ $0.price * $0.count }.reduce(0, +)
    }

    func getOrderFromStorage() -> Order? {
        order
    }

    // Получаем заказ из UserDefaults
    private func getOrderFromUserDefaults() {
        order = UserDefaults.standard.getOrder()
    }

    func setDeliveryTime(time: String) {
        deliveryTime = time
    }

    func configureOrder() {
        guard let orderPositions = castCartToOrder() else { print("OrderPositions is nil"); return }
        guard let address = getMainAddress()?.cityStreetHouse else { print("No main address"); return }
        order = Order(position: orderPositions, deliveryAddress: address, deliveryTime: deliveryTime, status: .inProgress)
    }

    private func castCartToOrder() -> [OrderPosition]? {
        guard let cart else { print("Cart is nil"); return nil}
        var orderPositions: [OrderPosition] = []
        for cartItem in cart.items {
            let position = OrderPosition(itemName: cartItem.item.name, size: cartItem.chosenSize, dough: cartItem.chosenDough, weight: cartItem.weight, price: cartItem.price, count: cartItem.count)
            orderPositions.append(position)
        }
        return orderPositions
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
