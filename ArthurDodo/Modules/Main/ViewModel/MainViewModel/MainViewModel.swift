import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {
    // MARK: - Published properties
    @Published private var cartPrice: Int?
    @Published private var stories: [Story]?
    @Published private var categories: [Category]?
    @Published private var promoItems: [Item]?
    @Published private var catalog: [Item]?
    @Published private var addressName: String?
    @Published private var userDodoCoins: Int?
    @Published private var state: ScreenState = .loading
    @Published private var orderPrice: Int?
    @Published private var orderStatus: String?
    @Published private var isShowOrderView: Bool?

    var cartPricePublisher: Published<Int?>.Publisher { $cartPrice }
    var storiesPublisher: Published<[Story]?>.Publisher { $stories }
    var categoriesPublisher: Published<[Category]?>.Publisher { $categories }
    var promoItemsPublisher: Published<[Item]?>.Publisher { $promoItems }
    var catalogPublisher: Published<[Item]?>.Publisher { $catalog }
    var addressNamePublisher: Published<String?>.Publisher { $addressName }
    var userDodoCoinsPublisher: Published<Int?>.Publisher { $userDodoCoins }
    var statePublisher: Published<ScreenState>.Publisher { $state }
    var orderPricePublisher: Published<Int?>.Publisher { $orderPrice }
    var orderStatusPublisher: Published<String?>.Publisher { $orderStatus }
    var isShowOrderViewPublisher: Published<Bool?>.Publisher { $isShowOrderView }

    lazy var addressDodoCoins = Publishers.CombineLatest(addressNamePublisher, userDodoCoinsPublisher)
    lazy var orderPublisher = Publishers.CombineLatest(orderStatusPublisher, orderPricePublisher)

    // MARK: - Other properties
    var onProfileButtonTapped: (() -> Void)?
    var onAddressButtonTapped: (() -> Void)?
    var onStoryTapped: ((IndexPath) -> Void)?
    var onProductDetailsTapped: (() -> Void)?
    var onCartButtonTapped: (() -> Void)?

    private let storage: MainStorage

    // MARK: - Init
    init(storage: MainStorage) {
        self.storage = storage
    }
}

// MARK: - MainViewModelProtocol
extension MainViewModel {
    // Основной загрузочный метод viewModel
    func initialize() {
        fetchData()
        isNeedToShowOrderView()
    }

    // Запрашиваем данные о стоимости заказа из хранилища и обновляем view
    func updateCart() {
        cartPrice = storage.getTotalOrderPrice()
    }

    // Запрашиваем данные о каталоге из хранилища, получаем конкретный товар, отмечаем его в хранилище как выбранный и открываем экран Product Details
    func itemSelected(at indexPath: IndexPath) {
        let catalog = storage.getCatalog()
        let item = catalog[indexPath.item]
        showSelectedItem(item)
    }

    // Запрашиваем данные из хранилища о спецпредложении, выбираем конкретный товар отмечаем его в хранилище как выбранный и открываем экран Product Details
    func promoItemSelected(at indexPath: IndexPath) {
        let specialOfferArray = storage.getSpecialOffersArray()
        let item = specialOfferArray[indexPath.item]
        showSelectedItem(item)
    }

    // Отрабатываем нажатие на кнопку профиля
    func profileButtonTapped() {
        onProfileButtonTapped?()
    }

    // Отрабатываем нажатие на кнопку адреса
    func addressButtonTapped() {
        onAddressButtonTapped?()
    }

    // Отрабатываем нажатие на сторис
    func storyTapped(at indexPath: IndexPath) {
        onStoryTapped?(indexPath)
    }

    // Отрабатываем нажатие на кнопку корзины
    func cartButtonTapped() {
        onCartButtonTapped?()
    }
}

// MARK: - Fetch data from server
private extension MainViewModel {
    // Обращаемся к хранилищу за необходимыми данными
    func fetchData() {
        getMainAddressFromStorage()
        getStoriesFromStorage()
        getCatalogAndSpecialOffersFromStorage()
    }

    // Забираем основной адрес из хранилища и обновляем view
    func getMainAddressFromStorage() {
        guard let mainAddress = storage.getMainAddress() else { print("Error: mainAddress is nil"); return }
        addressName = mainAddress.name
        userDodoCoins = storage.getDodoCoins()
    }

    // Забираем сторисы из хранилища и передаем их на view
    func getStoriesFromStorage() {
        stories = storage.getFetchedStories()
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromStorage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self else { return }
            getCategories()
            getSpecialOffers()
            getCatalog()
            setState(.success)
        }
    }

    // Получаем категории и передаем в коллекцию
    func getCategories() {
        categories = storage.getCategories()
    }

    // Получаем спецпредложения и передаем в коллекцию
    func getSpecialOffers() {
        promoItems = storage.getSpecialOffersArray()
    }

    // Получаем каталог и передаем в коллекцию
    func getCatalog() {
        catalog = storage.getCatalog()
    }

    // Получаем состояние и передаем в коллекцию
    func setState(_ state: ScreenState) {
        self.state = state
    }
}


// MARK: - Supporting methods
private extension MainViewModel {
    // Показать или не показать вью с заказом
    func isNeedToShowOrderView() {
        let isActiveOrder = UserDefaults.standard.isActiveOrder() // Проверяет у UserDefaults есть ли активный заказ

        // Только если заказ есть, то пересылаем данные во вью, если нет - то прячем поле с заказом
        isActiveOrder ? passOrderToView() : hideOrderView()
    }

    // Скрываем поле с заказом
    func hideOrderView() {
        isShowOrderView = false
    }

    // Забираем заказ из хранилища и отправляем его на вью
    func passOrderToView() {
        guard let order = storage.getOrder() else { print("We have no order in storage"); return }
        orderPrice = storage.getTotalOrderPrice()
        orderStatus = order.status.rawValue
    }

    // Отправляем выбранный товар в хранилище
    func sendSelectedItemToStorage(_ item: Item) {
        storage.sendSelectedItemToStorage(item)
    }

    func showSelectedItem(_ item: Item) {
        sendSelectedItemToStorage(item)
        onProductDetailsTapped?()
    }
}
