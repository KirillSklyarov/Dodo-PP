import Foundation

protocol CartViewControllerOutput: BaseViewControllerOutput where ActionType == CartPresenterAction {

    var coordinatorEventHandler: ((CartCoordinatorEvent) -> Void)? { get set }
}

enum CartPresenterAction {
    case dismissButtonTapped
    case emptyCartAction
    case deleteItemTapped(IndexPath)
    case changeCountOfItemsTapped(IndexPath, Int)
    case itemSelected(CartItem)
    case promoSelected(Promo)
    case addNewItemToCartTapped(CartItem)
    case cartButtonTapped
    case updateCart
}

final class CartPresenter {

    // MARK: - Published Properties
//    private var cartData: CartData?
    private var promo: [Promo]?
    private var itemsToAdd: [Item]?
    private var cart: Cart?
    private var countOfItemsInCart: Int?
    private var totalCartPrice: Int?

    // MARK: - Other properties
    private let storage: CartStorage
    private let storageService: DataStorageService

    weak var view: (any CartViewControllerInput)?

    var coordinatorEventHandler: ((CartCoordinatorEvent) -> Void)?

    // MARK: - Init
    init(storage: CartStorage, storageService: DataStorageService) {
        self.storage = storage
        self.storageService = storageService
    }
}

// MARK: - CartViewControllerOutput
extension CartPresenter: CartViewControllerOutput {
    // Когда получает инфу что view загрузилась, то выставляем view стартовое положение и загружаем данные
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    // Если какие-то данные не получили, то показываем ошибку, если все ок, то обновляем view
    func updateViewWithData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            isErrorState() ? setErrorState() : updateUI()
        }
    }

    // Event handler. Получаем от view действия пользователя и отрабатываем их (зачастую это переходы на экраны, поэтому вызывается coordinatorEventHandler)
    func sendAction(_ action: CartPresenterAction) {
        switch action {
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .emptyCartAction: coordinatorEventHandler?(.dismissModule)
        case .deleteItemTapped(let indexPath): deleteItemFromCart(indexPath)
        case .changeCountOfItemsTapped(let indexPath, let count): changeCountOfItem(indexPath, count)
        case .itemSelected(let item): selectItem(item)
        case .promoSelected(let promo): promoSelected(promo)
        case .addNewItemToCartTapped(let newItem): addNewItemToCart(newItem)
        case .cartButtonTapped: coordinatorEventHandler?(.showDeliveryModule)
        case .updateCart: updateCart()
        }
    }
}

// MARK: - Fetch Data
private extension CartPresenter {
    // Выставляем для view состояние loading Получаем данные из хранилища и обновляем view
    func loadData() {
        view?.showLoading()
        fetchData()
        updateViewWithData()
    }

    // Получаем данные из хранилища
    func fetchData() {
        getPromoFromStorage()
        getItemsToAddFromStorage()
        getCartFromStorage()
    }

    // Получаем данные об акциях из хранилища
    func getPromoFromStorage() {
        promo = storage.getPromo()
    }

    // Получаем товары, для отражения в корзине в категории "Добавить к заказу"
    func getItemsToAddFromStorage() {
        itemsToAdd = storageService.getSpecialOfferArray()
    }

    // Получаем заказ с хранилища, получаем данные о кол-ве и общей стоимости заказа
    func getCartFromStorage() {
        cart = storage.getCartFromStorage()
        countOfItemsInCart = storage.getCountOfItemsInCart()
        totalCartPrice = storage.getTotalCartPrice()
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        coordinatorEventHandler?(.showCartErrorAlertModule)
        view?.showError()
    }

    // В этом методе из разрозненных данных формируется корзина и обновляется view
    func updateUI() {
        let cartData = CartData(promo: promo!, itemsToAdd: itemsToAdd!, cart: cart!, countOfItemsInCart: countOfItemsInCart!, totalCartPrice: totalCartPrice!)
        view?.configure(with: cartData)
    }
}

// MARK: - Supporting methods
private extension CartPresenter {
    // Получаем данные из хранилища и обновляем view (используется когда закрываем окно редактирования)
    func updateCart() {
        print(#function)
        getCartFromStorage()
        updateUI()
    }

    func deleteItemFromCart(_ indexPath: IndexPath) {
        storage.removeItemFromCart(indexPath)
        updateCart()
    }

    func changeCountOfItem(_ indexPath: IndexPath, _ count: Int) {
        storage.changeCountOfItems(indexPath, count)
        updateCart()
    }

    // Нажали на ячейку в таблице с товаром, отправили редактируемый товар в хранилище и открыли экран с этим товаром, при закрытии этого экрана срабатывает комплишн и мы заново загружаем корзину
    func selectItem(_ item: CartItem) {
        storage.setChangingItem(item)
        coordinatorEventHandler?(.showEditProductModule)
    }

    // Срабатываем на нажатие на акцию (показывает окно с промоакцией)
    func promoSelected(_ promo: Promo) {
        storage.setSelectedPromo(promo)
        coordinatorEventHandler?(.showPromoModule)
    }

    // Добавляем новую позицию в заказ
    func addNewItemToCart(_ item: CartItem) {
        storage.addItemToCart(item: item)
        updateCart()
    }

    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isErrorState() -> Bool {
        let data: [Any?] = [promo, itemsToAdd, cart, countOfItemsInCart, totalCartPrice]
        return data.contains { $0 == nil }
    }
}
