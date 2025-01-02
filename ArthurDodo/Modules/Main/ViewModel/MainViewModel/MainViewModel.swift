import Foundation
import Combine

enum Action {
    case profileButtonTapped
    case addressButtonTapped
    case itemSelected(at: IndexPath)
    case storyTapped(at: IndexPath)
    case promoItemSelected(at: IndexPath)
    case cartButtonTapped
}

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

    @Published private var isShowProfileButton: Bool?
    @Published private var headerState: ScreenState?

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
    var isShowProfileButtonPublisher: Published<Bool?>.Publisher { $isShowProfileButton }

    var headerStatePublisher: Published<ScreenState?>.Publisher { $headerState }

    lazy var addressDodoCoins = Publishers.CombineLatest(addressNamePublisher, userDodoCoinsPublisher)
    lazy var orderPublisher = Publishers.CombineLatest(orderStatusPublisher, orderPricePublisher)

    // MARK: - Other properties
    var onProfileButtonTapped: (() -> Void)?
    var onAddressButtonTapped: (() -> Void)?
    var onStoryTapped: ((IndexPath) -> Void)?
    var onProductDetailsTapped: (() -> Void)?
    var onCartButtonTapped: (() -> Void)?

    private let storage: MainStorage
    private let featureTogglesService: FeatureToggleService

    // MARK: - Init
    init(storage: MainStorage, featureTogglesService: FeatureToggleService) {
        self.storage = storage
        self.featureTogglesService = featureTogglesService
    }
}

// MARK: - MainViewModelProtocol
extension MainViewModel {
    // Основной загрузочный метод viewModel
    func initialize() {
        checkFeatureToggle(featureType: .profile)
        fetchData()
        isNeedToShowOrderView()
    }

    // Запрашиваем данные о стоимости заказа из хранилища и обновляем view
    func updateCart() {
        cartPrice = storage.getCartPrice()
    }

    // Отрабатывает action
    func sendAction(_ action: Action) {
        switch action {
        case .profileButtonTapped: onProfileButtonTapped?()
        case .addressButtonTapped: onAddressButtonTapped?()
        case .itemSelected(let indexPath): itemSelected(at: indexPath)
        case .storyTapped(let indexPath): onStoryTapped?(indexPath)
        case .promoItemSelected(let indexPath): promoItemSelected(at: indexPath)
        case .cartButtonTapped: onCartButtonTapped?()
        }
    }
}

// MARK: - Feature Toggle
private extension MainViewModel {
    // Проверяется featureToggle (включена фича или нет)
    // Прячем значок profile на основном экране (нужно при выключенной фиче)
    func checkFeatureToggle(featureType: FeatureType) {
        let isEnabled = featureTogglesService.isFeatureEnabled(featureType: featureType)
        isShowProfileButton = isEnabled
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
        headerState = .loading
        guard let mainAddress = storage.getMainAddress() else { print("Error: mainAddress is nil"); return }
        addressName = mainAddress.name
        userDodoCoins = storage.getDodoCoins()
        headerState = .success
    }

    // Забираем сторисы из хранилища и передаем их на view
    func getStoriesFromStorage() {
        stories = storage.getFetchedStories()
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromStorage() {
        getCategories()
        getSpecialOffers()
        getCatalog()
//        setState(.success)
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
        orderPrice = storage.getCartPrice()
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
}
