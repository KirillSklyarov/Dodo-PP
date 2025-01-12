import UIKit

protocol EditItemViewControllerOutput: BaseViewControllerOutput where ActionType == EditItemAction {

    var coordinatorEventHandler: ((EditItemCoordinatorEvent) -> Void)? { get set }
}

// Enum который перечисляет действия viewModel
enum EditItemAction {
    case dismissButtonTapped
    case cartButtonTapped
    case itemSizeChanged(Size?)
    case itemDoughChanged(Dough?)
    case showPopupViewTapped(CpfcPopupView)
}

enum EditItemCoordinatorEvent {
    case dismissModule
    case showEditItemErrorAlertModule
    case cartButtonTapped
    case showPopupView(CpfcPopupView)
}

final class EditItemPresenter {

    // MARK: - Published properties
    private var cartItem: CartItem?
    private var toppings: [Topping]?
    private var productDetails: WeightPrice?

    // MARK: - Other properties
    private let storage: CartStorage
    weak var view: (any EditItemViewControllerInput)?

    var coordinatorEventHandler: ((EditItemCoordinatorEvent) -> Void)?

    // MARK: - Init
    init(storage: CartStorage) {
        self.storage = storage
    }
}

// MARK: - EditViewControllerOutput
extension EditItemPresenter: EditItemViewControllerOutput {
    // Когда получает инфу что view загрузилась, то выставляем view стартовое положение и загружаем данные
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    // Если какие-то данные не получили, то показываем ошибку, если все ок, то обновляем view
    func updateViewWithData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            isErrorState() ? setErrorState() : updateUI()
        }
    }

    // Event handler. Получаем от view действия пользователя и отрабатываем их (зачастую это переходы на экраны, поэтому вызывается coordinatorEventHandler)
    func sendAction(_ action: EditItemAction) {
        switch action {
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .cartButtonTapped: cartButtonTapped()
        case .itemSizeChanged(let size): itemSizeChanged(size)
        case .itemDoughChanged(let dough): itemDoughChanged(dough)
        case .showPopupViewTapped(let popupVC): showPopUP(popupVC)
        }
    }
}

// MARK: - Fetch Data
private extension EditItemPresenter {
    func loadData() {
        view?.showLoading()
        fetchData()
        updateViewWithData()
    }

    func fetchData() {
        fetchSelectedItem()
        fetchToppings()
    }

    func fetchSelectedItem() {
        cartItem = storage.getChangingCartItem()
        getProductDetails()
    }

    // Получаем данные по выбранному весу (вес, цену, КБЖУ)
    func getProductDetails() {
        guard let cartItem else { print("CartItem is nil"); return }
        let size = cartItem.chosenSize
        productDetails = storage.getProductDetails(cartItem, size: size)
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
private extension EditItemPresenter {
    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isErrorState() -> Bool {
        let data: [Any?] = [cartItem, toppings, productDetails]
        return data.contains { $0 == nil }
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        coordinatorEventHandler?(.showEditItemErrorAlertModule)
        view?.showError()
    }

    func updateUI() {
        guard let cartItem, let toppings, let productDetails else { return }
        print(cartItem)
        view?.configure(with: (cartItem, toppings, productDetails))
    }

    func cartButtonTapped() {
        guard let cartItem else { return }
        storage.changeItemInCart(cartItem)
        coordinatorEventHandler?(.cartButtonTapped)
    }

    // Когда изменился размер, то мы обновляем данные для элемента
    func itemSizeChanged(_ size: Size?) {
        guard let size else { print("1. We have some problems here"); return }
        updateCartItem(size)
        getProductDetails()
        updateUI()
    }

    func itemDoughChanged(_ dough: Dough?) {
        cartItem?.chosenDough = dough
    }

    //
    func showPopUP(_ popupVC: UIViewController) {
        guard let popupVC = popupVC as? CpfcPopupView else {
            print("No popupVC"); return }
        coordinatorEventHandler?(.showPopupView(popupVC))
    }

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
