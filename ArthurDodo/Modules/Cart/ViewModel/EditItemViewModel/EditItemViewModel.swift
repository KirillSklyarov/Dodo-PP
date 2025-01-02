import UIKit
import Combine

protocol EditItemViewModelProtocol {
    func initialize()
    func sendAction(_ action: EditItemAction)

    var cartItemPublisher: Published<CartItem?>.Publisher { get }
    var toppingsPublisher: Published<[Topping]?>.Publisher { get }
    var productDetailsPublisher: Published<WeightPrice?>.Publisher { get }

    var onCartButtonTapped: ( () -> Void )? { get set }
    var onDismissButtonTapped: ( () -> Void)? { get set }
    var onShowPopupVC: ( (CpfcPopupView) -> Void )? { get set }
}

// Enum который перечисляет действия viewModel
enum EditItemAction {
    case dismissButtonTapped
    case cartButtonTapped
    case itemSizeChanged(Size?)
    case itemDoughChanged(Dough?)
    case showPopupViewTapped(UIViewController)
}

final class EditItemViewModel {

    // MARK: - Published properties
    @Published private var cartItem: CartItem?
    @Published private var toppings: [Topping]?
    @Published private var productDetails: WeightPrice?

    var cartItemPublisher: Published<CartItem?>.Publisher { $cartItem }
    var toppingsPublisher: Published<[Topping]?>.Publisher { $toppings }
    var productDetailsPublisher: Published<WeightPrice?>.Publisher { $productDetails }

    // MARK: - Other properties
    var onCartButtonTapped: ( () -> Void )?
    var onDismissButtonTapped: ( () -> Void )?
    var onShowPopupVC: ( (CpfcPopupView) -> Void )?

    private let storage: CartStorage

    // MARK: - Init
    init(storage: CartStorage) {
        self.storage = storage
    }
}

// MARK: - EditItemViewModelProtocol
extension EditItemViewModel: EditItemViewModelProtocol {
    func initialize() {
        fetchData()
    }

    func sendAction(_ action: EditItemAction) {
        switch action {
        case .dismissButtonTapped: onDismissButtonTapped?()
        case .cartButtonTapped: cartButtonTapped()
        case .itemSizeChanged(let size): itemSizeChanged(size)
        case .itemDoughChanged(let dough): itemDoughChanged(dough)
        case .showPopupViewTapped(let popupVC): showPopUP(popupVC)
        }
    }
}

// MARK: - Supporting methods
private extension EditItemViewModel {
    func cartButtonTapped() {
        guard let cartItem else { return }
        storage.changeItemInCart(cartItem)
        onCartButtonTapped?()
    }

    func itemSizeChanged(_ size: Size?) {
        guard let size else { print("1. We have some problems here"); return }
        updateCartItem(size)
        updateUIWithChosenSize()
    }

    func itemDoughChanged(_ dough: Dough?) {
        cartItem?.chosenDough = dough
    }

    func showPopUP(_ popupVC: UIViewController) {
        guard let popupVC = popupVC as? CpfcPopupView else {
            print("No popupVC"); return }
        onShowPopupVC?(popupVC)
    }

    // Обновляем данные о выбранном весе
    func updateUIWithChosenSize() {
        guard let cartItem else { print("CartItem is nil"); return }
        let size = cartItem.chosenSize
        productDetails = storage.getProductDetails(cartItem, size: size)
    }
}

// MARK: - Fetch Data
private extension EditItemViewModel {
    func fetchData() {
        fetchSelectedItem()
        fetchToppings()
    }

    func fetchSelectedItem() {
        cartItem = storage.getChangingCartItem()
    }

    // Загружаем ВСЕ начинки
    func fetchToppings() {
        filterToppings()
    }

    // Отбираем только нужные нам начинки
    func filterToppings() {
        guard let cartItem else { return }
        toppings = storage.getFetchedToppings(for: cartItem)
    }
}

// MARK: - Supporting methods
private extension EditItemViewModel {
    // Этот метод получает правильную вес и цену в зависимости от выбранного веса
    func updateCartItem(_ size: Size) {
        guard var cartItem else { print("2. We have some problems here"); return }
        cartItem.chosenSize = size
        let correctWeight = storage.getCorrectWeight(cartItem, size)
        let correctPrice = storage.getCorrectPrice(cartItem, size)
        cartItem.weight = correctWeight
        cartItem.price = correctPrice
        self.cartItem = cartItem
    }
}


//    func updateUI() {
//        guard let cartItem else { print("Cart item is nil"); return }
//        updateUIWithCorrectSizeAndDough()
//        updateUIWithCorrectWeightAndIngredients()
////        view?.updateUIWithSelectedItem(cartItem)
//    }

//    func updateUIWithCorrectSizeAndDough() {
//        guard let cartItem else { return }
//        guard let dough = cartItem.chosenDough else { print("No dough"); return }
//        let size = cartItem.chosenSize
////        view?.updateSizeAndDough(size, dough)
//    }

//    func updateUIWithCorrectWeightAndIngredients() {
//        guard let cartItem else { print("Cart item is nil"); return }
////        view?.updateInfo(cartItem.item)
//    }

// Отправляем данные о топпингов дальше ко вью
//    func passToppingsToView(_ toppings: [Topping]) {
//        view?.updateToppings(toppings)
//    }
