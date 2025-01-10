import Foundation

final class CartPresenter {

    // MARK: - Published Properties
//    private var cartData: CartData?
    var promo: [Promo]?
    var itemsToAdd: [Item]?
    var cart: Cart?
    var countOfItemsInCart: Int?
    var totalCartPrice: Int?

//    var promoPublisher: Published<[Promo]?>.Publisher { $promo }
//    var itemsToAddPublisher: Published<[Item]?>.Publisher { $itemsToAdd }
//    var cartPublisher: Published<Cart?>.Publisher { $cart }
//    var countOfItemsInCartPublisher: Published<Int?>.Publisher { $countOfItemsInCart }
//    var totalCartPricePublisher: Published<Int?>.Publisher { $totalCartPrice }
//
//    lazy var countAndTotalPublishers = Publishers.CombineLatest(countOfItemsInCartPublisher, totalCartPricePublisher)

    // MARK: - Other properties
    var onCartVCDismissed: (() -> Void)?
    var onShowEditProductVC: (() -> Void)?
    var onShowPromoVC: (() -> Void)?
    var onShowDeliveryVC: (() -> Void)?

    var coordinatorEventHandler: ((CartCoordinatorEvent) -> Void)?

    private let storage: CartStorage
    private let storageService: DataStorageService

    weak var view: CartViewControllerInput?

    // MARK: - Init
    init(storage: CartStorage, storageService: DataStorageService) {
        self.storage = storage
        self.storageService = storageService
    }
}

// MARK: - CartViewControllerOutput
extension CartPresenter: CartViewControllerOutput {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    func sendAction(_ action: CartViewModelAction) {
        switch action {
        case .dismissButtonTapped: cartVCDismissed()
        case .emptyCartAction: cartIsEmpty()
        case .deleteItemTapped(let indexPath): deleteItemFromCart(indexPath)
        case .changeCountOfItemsTapped(let indexPath, let count): changeCountOfItem(indexPath, count)
        case .itemSelected(let item): selectItem(item)
        case .promoSelected(let promo): promoSelected(promo)
        case .addNewItemToCartTapped(let newItem): addNewItemToCart(newItem)
        case .cartButtonTapped: cartButtonTapped()
        case .updateCart: updateCart()
        }
    }
}

// MARK: - Fetch Data
private extension CartPresenter {
    func loadData() {
        view?.showLoading()
        fetchData()
        updateViewWithData()
    }

    func fetchData() {
        getPromoFromStorage()
        getItemsToAddFromStorage()
        getCartFromStorage()
    }

    // Получаем данные из хранилища и передаем их в коллекцию и выставляем состояние экрана
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

    // Если какие-то данные не получили, то показывает алерт с ошибкой, если все ок, то выставляем статус success
    func updateViewWithData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self,
                  let promo,
                  let itemsToAdd,
                  let cart,
                  let countOfItemsInCart,
                  let totalCartPrice else {
                self?.setErrorState(); return
            }
            let cartData = CartData(promo: promo, itemsToAdd: itemsToAdd, cart: cart, countOfItemsInCart: countOfItemsInCart, totalCartPrice: totalCartPrice)
            view?.configure(with: cartData)
        }
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        coordinatorEventHandler?(.showProfileErrorAlertModule)
        view?.showError()
    }
}


// MARK: - Supporting methods
private extension CartPresenter {
    func deleteItemFromCart(_ indexPath: IndexPath) {
        storage.removeItemFromCart(indexPath)
        getCartFromStorage()
    }

    func cartVCDismissed() {
        onCartVCDismissed?()
    }

    func cartIsEmpty() {
        onCartVCDismissed?()
    }

    func changeCountOfItem(_ indexPath: IndexPath, _ count: Int) {
        storage.changeCountOfItems(indexPath, count)
        getCartFromStorage()
    }

    // Нажали на ячейку в таблице с товаром, отправили редактируемый товар в хранилище и открыли экран с этим товаром, при закрытии этого экрана срабатывает комплишн и мы заново загружаем корзину
    func selectItem(_ item: CartItem) {
        storage.setChangingItem(item)
        onShowEditProductVC?()
    }

    // Срабатываем на нажатие на акцию (показывает окно с промоакцией)
    func promoSelected(_ promo: Promo) {
        storage.setSelectedPromo(promo)
        onShowPromoVC?()
    }

    // Добавляем новую позицию в заказ
    func addNewItemToCart(_ item: CartItem) {
        storage.addItemToCart(item: item)
        getCartFromStorage()
    }

    func cartButtonTapped() {
        onShowDeliveryVC?()
    }

    func updateCart() {
        getCartFromStorage()
    }
}


// Передаем данные в коллекцию и обновляем ее
//    func promoCollectionUpdateUI(_ promo: [Promo]) {
//        view?.promoCollectionUpdateUI(promo)
//        view?.setState(.success)
//    }
