import Foundation

protocol ItemDetailsViewControllerOutput: BaseViewControllerOutput where ActionType == ProductDetailsViewModelAction, CoordinatorEvent == ItemDetailsCoordinatorEvent {

}

enum ItemDetailsCoordinatorEvent {
    case dismissModule
    case showError
    case showPopupVC(CpfcPopupView)
}

enum ProductDetailsViewModelAction {
    case dismissButtonTapped
    case cartButtonTapped(Size, Dough)
    case itemSegmentValueChanged(Int)
    case showPopupVC(CpfcPopupView)
}

final class ItemDetailsPresenter {
    // MARK: - Published properties
    private var itemDetailsData = ItemDetailsData()

    private var item: Item?
    private var isOneSize: Bool?
    private var isDoughOption: Bool?
    private var weight: Int?
    private var price: Int?
    private var toppings: [Topping]?
    private var productDetails: WeightPrice?

//    var itemPublisher: Published<Item?>.Publisher { $item }
//    var isOneSizePublisher: Published<Bool?>.Publisher { $isOneSize }
//    var isDoughOptionPublisher: Published<Bool?>.Publisher { $isDoughOption }
//    var weightPublisher: Published<Int?>.Publisher { $weight }
//    var pricePublisher: Published<Int?>.Publisher { $price }
//    var toppingsPublisher: Published<[Topping]?>.Publisher { $toppings }
//    var productDetailsPublisher: Published<WeightPrice?>.Publisher { $productDetails }
//
//    lazy var weightPricePublisher = Publishers.CombineLatest(weightPublisher, pricePublisher)

    // MARK: - Other properties
    var coordinatorEventHandler: ((ItemDetailsCoordinatorEvent) -> Void)?

    private let storage: MainStorage

    weak var view: (any ItemDetailsViewControllerInput)?

    // MARK: - Init
    init(storage: MainStorage) {
        self.storage = storage
    }
}

// MARK: - ItemDetailsViewControllerOutput
extension ItemDetailsPresenter: ItemDetailsViewControllerOutput {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        view?.showLoading()
        fetchData()
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : setErrorState()
    }

    func sendAction(_ action: ProductDetailsViewModelAction) {
        switch action {
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .cartButtonTapped(let size, let dough): cartButtonTapped(size, dough)
        case .itemSegmentValueChanged(let index): itemSegmentValueChanged(index)
        case .showPopupVC(let popupVC): showPopupVC(popupVC)
        }
    }
}

// MARK: - Fetch Data
private extension ItemDetailsPresenter {
    func fetchData() {
        fetchSelectedItem()
        fetchToppings()
    }

    func fetchSelectedItem() {
        item = storage.getSelectedItemFromStorage()
        itemDetailsData = ItemDetailsData(item: item)
        updateUI()
    }

    func updateUI() {
        showOrHideSizeSegment()
        showOrHideDoughSegmentView()
        updateWeightAndPriceUI()
    }

    // Решаем показывать или нет сегмент с размерами (если товар имеет только один размер, то показывать сегмент контрол не надо)
    func showOrHideSizeSegment() {
        guard let item else { return }
        itemDetailsData.isOneSize = item.hasOneSize()
        isOneSize = item.hasOneSize() ? true : false
    }

    // Решаем показывать или нет сегмент с тестом (если товар не пицца, то показывать тесто не надо)
    func showOrHideDoughSegmentView() {
        guard let item else { return }
        let isPizza = item.category == .pizza
        isDoughOption = isPizza
        itemDetailsData.isDoughOption = isPizza
    }

    // Обновляем вес и цену товара
    func updateWeightAndPriceUI() {
        guard let item else { return }
        if item.hasOneSize() {
            itemDetailsData.weight = item.itemSize.oneSize?.weight
            itemDetailsData.price = item.itemSize.oneSize?.price
        }
    }

    // Загружаем начинки
    func fetchToppings() {
        guard let fetchedToppings = item?.toppings else { return }
        toppings = fetchedToppings
    }
}

// MARK: - Supporting methods
private extension ItemDetailsPresenter {
    func isDataValid() -> Bool {
        return item != nil
    }

    func updateView() {
        view?.configure(with: itemDetailsData)
    }

    func setErrorState() {
        view?.showError()
    }

    // При нажатии на кнопку корзины мы формируем заказ, добавляем позицию в заказ и отрабатываем замыкания
    func cartButtonTapped(_ size: Size, _ dough: Dough) {
        guard let itemToCart = configureCart(size, dough) else { return }
        storage.addItemToCart(itemToCart)
        coordinatorEventHandler?(.dismissModule)
    }

    // Когда меняются значения на сегментах (вес), то мы обновляем на вью вес товара и цену товара
    func itemSegmentValueChanged(_ index: Int) {
        productDetails = item?.itemSize.getWeightAndPriceViaIndex(index)
        guard let productDetails else { return }
        view?.changeViewWithSelectedSize(productDetails)
    }

    // Показываем экран с КБЖУ
    func showPopupVC(_ popupVC: CpfcPopupView) {
        coordinatorEventHandler?(.showPopupVC(popupVC))
    }

    func configureCart(_ size: Size, _ dough: Dough) -> CartItem? {
        guard let item else { return nil}
        let chosenSize = getCorrectSize(size)
        let chosenDough = getCorrectDough(dough)
        let weight = item.getWeight(size: chosenSize)
        let price = item.getPrice(size: chosenSize)
        let isOneSize = item.hasOneSize()

        let positionToAddToCart = CartItem(item: item, chosenSize: chosenSize, chosenDough: chosenDough, weight: weight, price: price, isOneSize: isOneSize)
        return positionToAddToCart
    }

    // Если есть размер oneSize, то берем его, если нет - выбранный размер
    func getCorrectSize(_ size: Size) -> Size {
        guard let item else { return .oneSize }
        let chosenSize = size
        let correctSize = item.hasOneSize() ? .oneSize : chosenSize
        return correctSize
    }

    // Если товар - пицца, то берем тесто, если нет - ничего
    func getCorrectDough(_ dough: Dough) -> Dough? {
        guard let item else { return nil }
        let chosenDough = dough
        let correctDough = item.category == .pizza ? chosenDough : nil
        return correctDough
    }

    func getCorrectWeight() -> Int {
        guard let item else { return 0 }
        var weight: Int?
        if item.hasOneSize() {
            weight = item.itemSize.oneSize?.weight
        } else {
            weight = item.itemSize.medium?.weight
        }
        return weight ?? 0
    }
}
