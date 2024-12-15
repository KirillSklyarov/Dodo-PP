import Foundation

protocol CartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func updateCart()
    func deleteItemFromCart(_ indexPath: IndexPath)
    func changeCountOfItem(_ indexPath: IndexPath, _ count: Int)
    func selectItem(_ item: CartItem)
    func promoSelected(_ promo: Promo)
    func addNewItemToCartTapped(_ item: CartItem)
    func cartButtonTapped()
    func cartVCDismissed()
    func cartIsEmpty()

    var onCartVCDismissed: (() -> Void)? { get set }
    var onShowEditProductVC: (() -> Void)? { get set }
    var onShowPromoVC: ((Promo) -> Void)? { get set }
    var onShowDeliveryVC: (() -> Void)? { get set }
}

final class CartPresenter {
    weak var view: CartViewProtocol?

    // MARK: - Other Properties
    private let storage: CartStorage
    private let storageService: DataStorage

    private var state: ScreenState = .loading

    var onCartVCDismissed: (() -> Void)?
    var onShowEditProductVC: (() -> Void)?
    var onShowPromoVC: ((Promo) -> Void)?
    var onShowDeliveryVC: (() -> Void)?

    init(storageService: DataStorage) {
        self.storage = storageService.cartStorage
        self.storageService = storageService
    }

    func viewDidLoad() {
        fetchData()
    }

    func updateCart() {
        getCartFromStorage()
    }
}

// MARK: - Fetch Data
private extension CartPresenter {
    func fetchData() {
        getPromoFromStorage()
        getItemsToAddFromStorage()
        getCartFromStorage()
        setState(.success)
    }

    // Получаем данные из хранилища и передаем их в коллекцию и выставляем состояние экрана
    func getPromoFromStorage() {
        let promo = storage.getPromo()
        promoCollectionUpdateUI(promo)
        view?.setState(.success)
    }

    // Получаем товары, для отражения в корзине в категории "Добавить к заказу"
    func getItemsToAddFromStorage() {
        let itemsToAdd = storageService.getSpecialOfferArray()
        sendItemsToAdd(itemsToAdd)
    }

    // Получаем заказ с хранилища и передаем его в таблицу
    func getCartFromStorage() {
        guard let order = storage.getCartFromStorage() else { print("Cart not found in storage"); return }
        passCartToView(order)
        updateUI()
    }

    // Обновляем данные о кол-ве и общей стоимости заказа на UI
    func updateUI() {
        let countOfItems = storage.getCountOfItemsInCart()
        let totalPrice = storage.getTotalCartPrice()
        view?.updateUI(countOfItems, totalPrice)
    }

    // Передаем данные в коллекцию и обновляем ее
    func promoCollectionUpdateUI(_ promo: [Promo]) {
        view?.promoCollectionUpdateUI(promo)
    }

    // Отправляем актуальный заказ далее для отражения на след вьюхе
    func passCartToView(_ cart: Cart) {
        view?.updateCart(cart)
    }
}

// MARK: - CartPresenterProtocol
extension CartPresenter: CartPresenterProtocol {
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
        onShowPromoVC?(promo)
    }

    // Добавляем новую позицию в заказ
    func addNewItemToCartTapped(_ item: CartItem) {
        storage.addItemToCart(item: item)
        getCartFromStorage()
    }

    func cartButtonTapped() {
        onShowDeliveryVC?()
    }

    // Устанавливает состояние экрана
    func setState(_ state: ScreenState) {
        self.state = state
    }
}

// MARK: - Supporting methods
private extension CartPresenter {
    // Отправляем товары для отражения в категории "Добавить к заказу" на view
    func sendItemsToAdd(_ items: [Item]) {
        view?.updateItemsToAdd(items)
    }
}
