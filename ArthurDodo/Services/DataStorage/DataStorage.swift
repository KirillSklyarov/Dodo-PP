import Foundation

final class DataStorage {

    // MARK: - Properties
    private var fetchedUserAddresses: [Address] = []
    private var fetchedToppings: [Topping] = []
    private var fetchedStories: [Story] = []
    private var fetchedItems: [Item] = []
    private var fetchedPromo: [Promo] = []
    private var fetchedPersonalData: Personal?
    private var category: [CategoryName] = []
    private var order: [Order] = []
    private var specialOfferArray: [Item] = []
    private var selectedItem: Item?
    private lazy var preferredPaymentMethod: PaymentMethod = .cbp

    private var networkManager: NetworkManager

    // MARK: - Callbacks
    var onDataFetchedSuccessfully: (() -> Void)?
    var onToppingsFetchedSuccessfully: (([Topping]) -> Void)?
    var onStoriesFetchedSuccessfully: (([Story]) -> Void)?
    var onItemsFetchedSuccessfully: (() -> Void)?
    var onPromoFetchedSuccessfully: (([Promo]) -> Void)?
    var onPersonalDataFetchedSuccessfully: ((Personal) -> Void)?

    // MARK: - Init
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

// MARK: - Personal
extension DataStorage {
    // Фетчим личные данные
    func fetchPersonalData() {
        networkManager.fetchData(.personal) { [weak self] (result: Result<Personal, NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let personalData):
                fetchedPersonalData = personalData
                onPersonalDataFetchedSuccessfully?(personalData)
            case .failure(let error):
                print(error)
            }
        }
    }

    // Отдаем личные данные
    func getPersonalData() -> Personal? {
        fetchedPersonalData
    }

    // Проверяем были ли ранее загружены данные
    func isPersonalDataLoaded() -> Bool {
        fetchedPersonalData != nil
    }
}

// MARK: - User Addresses
extension DataStorage {
    func fetchUserAddresses() {
        networkManager.fetchData(.userAddress) { [weak self] (result: Result<[Address], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let addresses):
                fetchedUserAddresses = addresses
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

    func isAddressesEmpty() -> Bool {
        fetchedUserAddresses.isEmpty
    }

    func getAddresses() -> [Address] {
        fetchedUserAddresses
    }

    func getMainAddress() -> Address? {
        fetchedUserAddresses.first(where: \.isMain)
    }

    // Мы обнуляем для всех isMain и назначаем для нового, и потом сортируем чтобы isMain был первым
    func setNewMainAddress(_ newMainAddress: String) {
        let newAddresses = fetchedUserAddresses.map { address in
            var newAddress = address
            newAddress.isMain = (newAddress.name == newMainAddress)
            return newAddress
        }
        fetchedUserAddresses = newAddresses.sortedMainFirst()
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
        selectedItem = item
    }

    // Отправляет выбранный товар, то есть тот, который открыл пользователь
    func getSelectedItemFromStorage() -> Item? {
        selectedItem
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

    func getCategories() -> [CategoryName] {
        category
    }
}

// MARK: - Orders
extension DataStorage {
    func addItemToOrder(_ item: Order) {
        self.order.append(item)
    }

    func increaseCountOfItem(_ indexPath: IndexPath, _ value: Int) {
        order[indexPath.row].count = value
    }

    func removeItemFromOrderStorage(_ indexPath: IndexPath) {
        order.remove(at: indexPath.row)
    }

    func getOrderFromStorage() -> [Order] {
        order
    }

    func getTotalOrderPrice() -> Int {
        order.compactMap{ $0.price * $0.count }.reduce(0, +)
    }

    func getCountOfItems() -> Int {
        order.compactMap{ $0.count }.reduce(0, +)
    }

    // Очищаем заказы (нужно при отправке заказа к исполнению)
    func eraseOrder() {
        order = []
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
            print("Default payment method = .cbp")
        }
    }
}
