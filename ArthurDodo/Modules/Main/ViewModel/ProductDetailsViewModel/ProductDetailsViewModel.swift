import Foundation
import Combine

// MARK: - Protocol
protocol ProductDetailsViewModelProtocol: BaseViewModelProtocol where ActionType == ProductDetailsViewModelAction {

    var itemPublisher: Published<Item?>.Publisher { get }
    var isOneSizePublisher: Published<Bool?>.Publisher { get }
    var isDoughOptionPublisher: Published<Bool?>.Publisher { get }
    var weightPricePublisher: Publishers.CombineLatest<Published<Int?>.Publisher, Published<Int?>.Publisher> { get }
    var toppingsPublisher: Published<[Topping]?>.Publisher { get }
    var productDetailsPublisher: Published<WeightPrice?>.Publisher { get }

    var onCartButtonTapped: ( () -> Void )? { get }
    var onDismissButtonTapped: ( () -> Void )? { get set }
    var onShowPopupVC: ( (CpfcPopupView) -> Void)? { get set }
}

enum ProductDetailsViewModelAction {
    case dismissButtonTapped
    case cartButtonTapped(Size, Dough)
    case itemSegmentValueChanged(Int)
    case showPopupVC(CpfcPopupView)
}

final class ProductDetailsViewModel {
    // MARK: - Published properties
    @Published private var item: Item?
    @Published private var isOneSize: Bool?
    @Published private var isDoughOption: Bool?
    @Published private var weight: Int?
    @Published private var price: Int?
    @Published private var toppings: [Topping]?
    @Published private var productDetails: WeightPrice?

    var itemPublisher: Published<Item?>.Publisher { $item }
    var isOneSizePublisher: Published<Bool?>.Publisher { $isOneSize }
    var isDoughOptionPublisher: Published<Bool?>.Publisher { $isDoughOption }
    var weightPublisher: Published<Int?>.Publisher { $weight }
    var pricePublisher: Published<Int?>.Publisher { $price }
    var toppingsPublisher: Published<[Topping]?>.Publisher { $toppings }
    var productDetailsPublisher: Published<WeightPrice?>.Publisher { $productDetails }

    lazy var weightPricePublisher = Publishers.CombineLatest(weightPublisher, pricePublisher)

    // MARK: - Other properties
    var onCartButtonTapped: ( () -> Void )?
    var onDismissButtonTapped: ( () -> Void )?
    var onShowPopupVC: ( (CpfcPopupView) -> Void)?

    private let storage: MainStorage

    // MARK: - Init
    init(storage: MainStorage) {
        self.storage = storage
    }
}

// MARK: - ProductDetailsViewModelProtocol
extension ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    func initialize() {
        fetchData()
    }

    func sendAction(_ action: ProductDetailsViewModelAction) {
        switch action {
        case .dismissButtonTapped: onDismissButtonTapped?()
        case .cartButtonTapped(let size, let dough): cartButtonTapped(size, dough)
        case .itemSegmentValueChanged(let index): itemSegmentValueChanged(index)
        case .showPopupVC(let popupVC): showPopupVC(popupVC)
        }
    }

    // При нажатии на кнопку корзины мы формируем заказ, добавляем позицию в заказ и отрабатываем замыкания
    func cartButtonTapped(_ size: Size, _ dough: Dough) {
        guard let itemToCart = configureCart(size, dough) else { return }
        storage.addItemToCart(itemToCart)
        onCartButtonTapped?()
        onDismissButtonTapped?()
    }

    // Когда меняются значения на сегментах (вес), то мы обновляем на вью вес товара и цену товара
    func itemSegmentValueChanged(_ index: Int) {
        productDetails = item?.itemSize.getWeightAndPriceViaIndex(index)
    }

    // Показываем экран с КБЖУ
    func showPopupVC(_ popupVC: CpfcPopupView) {
        onShowPopupVC?(popupVC)
    }
}

// MARK: - Fetch Data
private extension ProductDetailsViewModel {
    func fetchData() {
        fetchSelectedItem()
        fetchToppings()
    }

    func fetchSelectedItem() {
        item = storage.getSelectedItemFromStorage()
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
        isOneSize = item.hasOneSize() ? true : false
    }

    // Решаем показывать или нет сегмент с тестом (если товар не пицца, то показывать тесто не надо)
    func showOrHideDoughSegmentView() {
        guard let item else { return }
        let isPizza = item.category == .pizza
        isDoughOption = isPizza
    }

    // Обновляем вес и цену товара
    func updateWeightAndPriceUI() {
        guard let item else { return }
        if item.hasOneSize() {
            weight = item.itemSize.oneSize?.weight
            price = item.itemSize.oneSize?.price
        }
    }

    // Загружаем ВСЕ начинки
    func fetchToppings() {
        filterToppings()
    }

    // Отбираем только нужные нам начинки и отправляем данные о топпингах дальше ко вью
    func filterToppings() {
        guard let fetchedToppings = item?.toppings else { return }
        toppings = fetchedToppings
    }
}

// MARK: - Supporting methods
private extension ProductDetailsViewModel {
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
