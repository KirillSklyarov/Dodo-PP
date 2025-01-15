import Foundation

protocol MainViewControllerOutput: BaseViewControllerOutput where ActionType == MainAction, CoordinatorEvent == MainCoordinatorEvent {

}

// Enum действий юзера
enum MainAction {
    case profileButtonTapped
    case addressButtonTapped
    case itemSelected(at: IndexPath)
    case storyTapped(at: IndexPath)
    case promoItemSelected(at: IndexPath)
    case cartButtonTapped
    case updateCart
}

final class MainPresenter {

    // MARK: - Properties
    private var mainData: MainData?
    var coordinatorEventHandler: ((MainCoordinatorEvent) -> Void)?

    weak var view: (any MainViewControllerInput)?

    private let storage: MainStorage
    private let featureTogglesService: FeatureToggleService

    // MARK: - Init
    init(storage: MainStorage, featureTogglesService: FeatureToggleService) {
        self.storage = storage
        self.featureTogglesService = featureTogglesService
    }
}

// MARK: - MainViewControllerOutput
extension MainPresenter: MainViewControllerOutput {
    // Когда узнаем что view загружено, то выставляем для view стартовое состояние, загружаем данные и делаем проверку на ошибку
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    // Выставляем состояние loading для view, фетчим данные, делаем проверку на featureToggle и проверяем есть ли активный заказ
    func loadData() {
        view?.showLoading()
        fetchData()
        checkFeatureToggle(featureType: .profile)
        isNeedToShowOrderView()
    }

    // Если данные валидны, то обновляем view, если нет - показываем ошибку
    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : setErrorState()
    }

    // Отрабатывает действия юзера на view
    func sendAction(_ action: MainAction) {
        switch action {
        case .profileButtonTapped: coordinatorEventHandler?(.showProfile)
        case .addressButtonTapped: coordinatorEventHandler?(.showAddress)
        case .itemSelected(let indexPath): itemSelected(at: indexPath)
        case .storyTapped(let indexPath): coordinatorEventHandler?(.showStories(indexPath))
        case .promoItemSelected(let indexPath): promoItemSelected(at: indexPath)
        case .cartButtonTapped: coordinatorEventHandler?(.showCart)
        case .updateCart: updateCart()
        }
    }
}

// MARK: - Supporting methods
private extension MainPresenter {
    // Запрашиваем данные о стоимости заказа из хранилища и обновляем view
    func updateCart() {
        guard var mainData else { print("MainData is nil"); return }
        let cartPrice = storage.getCartPrice()
        mainData.cartPrice = cartPrice
        view?.updateCart(with: mainData)
    }

    func isDataValid() -> Bool {
        return mainData != nil
    }

    func updateView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            guard let mainData else { return }
            view?.configure(with: mainData)
        }
    }

    func setErrorState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            view?.showError()
            coordinatorEventHandler?(.showError)
        }
    }
}

// MARK: - Fetch data from server
private extension MainPresenter {
    // Обращаемся к хранилищу за необходимыми данными
    func fetchData() {
        getMainAddressFromStorage()
        getStoriesFromStorage()
        getCatalogAndSpecialOffersFromStorage()
    }

    // Забираем основной адрес из хранилища и обновляем view
    func getMainAddressFromStorage() {
        guard let mainAddress = storage.getMainAddress() else { print("Error: mainAddress is nil"); return }
        let userDodoCoins = storage.getDodoCoins()
        let headerData = HeaderData(mainAddress: mainAddress.name, userDodoCoins: userDodoCoins)
        mainData = MainData(headerData: headerData)
    }

    // Забираем сторисы из хранилища и передаем их на view
    func getStoriesFromStorage() {
        let stories = storage.getFetchedStories()
        mainData?.stories = stories
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromStorage() {
        getSpecialOffers()
        getCategories()
        getCatalog()
    }

    // Получаем спецпредложения и передаем в коллекцию
    func getSpecialOffers() {
        let promoItems = storage.getSpecialOffersArray()
        mainData?.promoItems = promoItems
    }

    // Получаем категории и передаем в коллекцию
    func getCategories() {
        let categories = storage.getCategories()
        mainData?.categories = categories
    }

    // Получаем каталог и передаем в коллекцию
    func getCatalog() {
        let catalog = storage.getCatalog()
        mainData?.catalog = catalog
    }
}

// MARK: - Feature Toggle
private extension MainPresenter {
    // Проверяется featureToggle (включена фича или нет)
    // Прячем значок profile на основном экране (нужно при выключенной фиче)
    func checkFeatureToggle(featureType: FeatureType) {
        let isEnabled = featureTogglesService.isFeatureEnabled(featureType: featureType)
        mainData?.featureToggle = [featureType: isEnabled]
    }
}

// MARK: - Supporting methods
private extension MainPresenter {
    // Показать или не показать вью с заказом
    func isNeedToShowOrderView() {
        let isActiveOrder = UserDefaults.standard.isActiveOrder() // Проверяет у UserDefaults есть ли активный заказ

        // Только если заказ есть, то пересылаем данные во вью, если нет - то прячем поле с заказом
        isActiveOrder ? passOrderToView() : hideOrderView()
    }

    // Скрываем поле с заказом
    func hideOrderView() {
        mainData?.order = OrderDetails(isActiveOrder: false)
    }

    // Забираем заказ из хранилища и отправляем его на вью
    func passOrderToView() {
        guard let order = storage.getOrder() else { print("We have no order in storage"); return }
        let orderPrice = storage.getCartPrice()
        let orderStatus = order.status.rawValue

        mainData?.order = OrderDetails(isActiveOrder: true, orderPrice: orderPrice, orderStatus: orderStatus)
    }

    // Отправляем выбранный товар в хранилище
    func sendSelectedItemToStorage(_ item: Item) {
        storage.sendSelectedItemToStorage(item)
    }

    func showSelectedItem(_ item: Item) {
        sendSelectedItemToStorage(item)
        coordinatorEventHandler?(.showItemDetails)
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
