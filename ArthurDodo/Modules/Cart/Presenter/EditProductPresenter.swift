import UIKit

final class EditProductPresenter {
    // MARK: - View
    weak var view: EditProductViewController?

    // MARK: - Other Properties
    private let storage: CartStorage

    private var cartItem: CartItem?
    private var toppings: [Topping] = []

    var onCartButtonTapped: ( () -> Void )?
    var onDismissButtonTapped: ( () -> Void )?
    var onShowPopupVC: ( (CpfcPopupView) -> Void )?

    // MARK: - Init
    init(storage: CartStorage) {
        self.storage = storage
    }

    func viewDidLoad() {
        fetchData()
    }
}

// MARK: - Fetch Data
private extension EditProductPresenter {
    func fetchData() {
        fetchSelectedItem()
        fetchToppings()
    }

    func fetchSelectedItem() {
        guard let cartItem = storage.getChangingCartItem() else { print("No changing item"); return }
        self.cartItem = cartItem
        updateUI()
    }

    func updateUI() {
        guard let cartItem else { print("Cart item is nil"); return }
        updateUIWithCorrectSizeAndDough()
        updateUIWithCorrectWeightAndIngredients()
        view?.updateUIWithSelectedItem(cartItem)
    }

    func updateUIWithCorrectSizeAndDough() {
        guard let cartItem else { return }
        guard let dough = cartItem.chosenDough else { print("No dough"); return }
        let size = cartItem.chosenSize
        view?.updateSizeAndDough(size, dough)
    }

    func updateUIWithCorrectWeightAndIngredients() {
        guard let cartItem else { print("Cart item is nil"); return }
        view?.updateInfo(cartItem.item)
    }

    // Загружаем ВСЕ начинки
    func fetchToppings() {
        filterToppings()
    }

    // Отбираем только нужные нам начинки
    func filterToppings() {
        guard let cartItem else { return }
        guard let toppings = storage.getFetchedToppings(for: cartItem) else { return }
        passToppingsToView(toppings)
    }

    // Отправляем данные о топпингов дальше ко вью
    func passToppingsToView(_ toppings: [Topping]) {
        view?.updateToppings(toppings)
    }
}

extension EditProductPresenter {

    func cartButtonTapped() {
        guard let cartItem else { return }
        storage.changeItemInCart(cartItem)
        onCartButtonTapped?()
    }

    func itemSizeChanged(_ size: Size?) {
        guard let size else { print("1. We have some problems here"); return }
        cartItem?.chosenSize = size
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

    func updateUIWithChosenSize() {
        guard let cartItem else { print("CartItem is nil"); return }
        let size = cartItem.chosenSize
        guard let productDetails = storage.getProductDetails(cartItem, size: size) else {print("2. We have some problems here"); return }
        self.cartItem?.price = productDetails.price
        view?.updateUIWithChosenSize(productDetails)
    }
}
