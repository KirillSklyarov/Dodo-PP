import Foundation

final class DataStorageService {
    private let profileStorage: ProfileStorage
    private let addressStorage: AddressStorage
    private let cartStorage: CartStorage
    private let mainStorage: MainStorage
    private let deliveryStorage: DeliveryStorage

    init(profileStorage: ProfileStorage, addressStorage: AddressStorage, cartStorage: CartStorage, mainStorage: MainStorage, deliveryStorage: DeliveryStorage) {
        self.profileStorage = profileStorage
        self.addressStorage = addressStorage
        self.cartStorage = cartStorage
        self.mainStorage = mainStorage
        self.deliveryStorage = deliveryStorage
    }
}

    // MARK: - Common methods (методы, которые будут использоваться из разных модулей)
extension DataStorageService {
    // Устанавливает новый главный адрес и обновляет соответствующее хранилище
    func setNewMainAddress(_ newMainAddressName: String) {
        guard let updatedUserData = updateUserData(with: newMainAddressName) else { return }
        profileStorage.setUserData(updatedUserData)
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
        guard let userAddresses = profileStorage.getUserAddresses() else { print("userAddresses is nil"); return []}
        return userAddresses
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

// MARK: - Supporting methods
private extension DataStorageService {
    // Получаем данные пользователя из хранилища и заменяем старый главный адрес на новый адрес (обнуляем для всех isMain и назначаем для нового, и потом сортируем чтобы isMain был первым)
    func updateUserData(with newMainAddressName: String) -> User? {
        guard var fetchedUserData = profileStorage.getUserData() else { print("fetchedUserData is nil"); return nil }
        let addresses = fetchedUserData.address
        let newAddresses = addresses.map { address in
            var newAddress = address
            newAddress.isMain = (newAddress.name == newMainAddressName)
            return newAddress
        }
        fetchedUserData.address = newAddresses.sortedMainFirst()
        return fetchedUserData
    }
}
