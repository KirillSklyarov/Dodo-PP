import Foundation

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func updateCart()
    func itemSelected(at indexPath: IndexPath)
    func promoItemSelected(at indexPath: IndexPath)
    func profileButtonTapped()
    func addressButtonTapped()
    func storyTapped(at indexPath: IndexPath)
    func cartButtonTapped()

    var onProfileButtonTapped: (() -> Void)? { get set }
    var onAddressButtonTapped: (() -> Void)? { get set }
    var onStoryTapped: ((IndexPath) -> Void)? { get set }
    var onProductDetailsTapped: (() -> Void)? { get set }
    var onCartButtonTapped: (() -> Void)? { get set }
}

final class MainPresenter {
    weak var view: MainViewControllerProtocol?

    // MARK: - Other properties
    private var state: ScreenState = .loading

    private let storage: MainStorage

    var onProfileButtonTapped: (() -> Void)?
    var onAddressButtonTapped: (() -> Void)?
    var onStoryTapped: ((IndexPath) -> Void)?
    var onProductDetailsTapped: (() -> Void)?
    var onCartButtonTapped: (() -> Void)?

    // MARK: - Init
    init(storage: MainStorage) {
        self.storage = storage
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    // Основной загрузочный метод презентера
    func viewDidLoad() {
        fetchData()
        isNeedToShowOrderView()
    }

    // Запрашиваем данные о стоимости заказа из хранилища и обновляем view
    func updateCart() {
        let totalPrice = storage.getTotalOrderPrice()
        view?.updateCart(with: totalPrice)
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
        let addressName = mainAddress.name
        let userDodoCoins = storage.getDodoCoins()
        view?.updateHeaderView(addressName, userDodoCoins)
    }

    // Забираем сторисы из хранилища и передаем их на view
    func getStoriesFromStorage() {
        let stories = storage.getFetchedStories()
        view?.passStoriesToContentCollectionView(stories)
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
        let categories = storage.getCategories()
        view?.passCategoriesToContentCollectionView(categories)
    }

    // Получаем спецпредложения и передаем в коллекцию
    func getSpecialOffers() {
        let specialOffersArray = storage.getSpecialOffersArray()
        view?.passPromoToContentCollectionView(specialOffersArray)
    }

    // Получаем каталог и передаем в коллекцию
    func getCatalog() {
        let catalog = storage.getCatalog()
        view?.passCatalogToContentCollectionView(catalog)
    }

    // Получаем состояние и передаем в коллекцию
    func setState(_ state: ScreenState) {
        self.state = state
        view?.setStateOnContentCollectionView(state)
    }
}


// MARK: - Supporting methods
private extension MainPresenter {
    // Показать или не показать вью с заказом
    func isNeedToShowOrderView() {
        let isActiveOrder = UserDefaults.standard.isActiveOrder() // Проверяет у UserDefaults есть ли активный заказ

        // Только если заказ есть, то пересылаем данные во вью
        if isActiveOrder { passOrderToView() }

        view?.isShowOrderView(isActiveOrder)
    }

    // Забираем заказ из хранилища и отправляем его на вью
    func passOrderToView() {
        guard let order = storage.getOrder() else { print("We have no order in storage"); return }
        let totalPrice = storage.getTotalOrderPrice()
        view?.updateOrder(order, totalPrice)
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
