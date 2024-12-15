import Foundation

final class MainStorage {

    // MARK: - Properties
    let storageService: DataStorage

    private var fetchedItems: [Item] = []
    private var specialOfferArray: [Item] = []
    private var fetchedStories: [Story] = []
    private var category: [Category] = []
    private var selectedItem: SelectedItem?
    private var editingItem: CartItem?

    // MARK: - Init
    init(storageService: DataStorage) {
        self.storageService = storageService
    }
}

extension MainStorage {

    func getTotalOrderPrice() -> Int {
        storageService.getTotalOrderPrice()
    }

    // Отправляет весь каталог товаров
    func getCatalog() -> [Item] {
        fetchedItems
    }

    func getMainAddress() -> Address? {
       storageService.getMainAddress()
    }

    func getDodoCoins() -> Int {
        storageService.getDodoCoins()
    }

    func getOrder() -> Order? {
        storageService.getOrder()
    }

    func addItemToCart(_ item: CartItem) {
        storageService.addItemToCart(itemToCart: item)
    }
}

// MARK: - Stories
extension MainStorage {
    func setStories(_ stories: [Story]) {
        fetchedStories = stories
    }

    func getFetchedStories() -> [Story] {
        fetchedStories
    }
}

// MARK: - Special Offers
extension MainStorage {
    // Из всего каталога выбираем кол-во (countOfElements) рандомных элементов
    func getArrayOfRandomItems(_ countOfElements: Int) {
        specialOfferArray = SpecialOffer.configRandomOffer(fetchedItems, countOfElements)
    }

    // Отдает специальные предложения
    func getSpecialOffersArray() -> [Item] {
        specialOfferArray
    }
}

// MARK: - Categories
extension MainStorage {
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

// MARK: - Catalog
extension MainStorage {
    // Принимаем полученные данные в хранилище
    func setCatalog(_ items: [Item]) {
        fetchedItems = items.sorted { $0.category.rawValue < $1.category.rawValue }
        getArrayOfRandomItems(5)
        getCategoriesFromCatalog()
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
        if editingItem != nil {
            return castChangingItemToItem()
        } else {
            return getSelectedItemFromStorage()
        }
    }

    // Возвращает товар для редактирования, но в виде Item
    func getChangingItem() -> Item? {
        guard let editingItem else { return nil }
        return editingItem.item
    }

    // Возвращает товар для редактирования (в виде CartItem)
    func getChangingCartItem() -> CartItem? {
        editingItem
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
