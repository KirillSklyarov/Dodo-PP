import Foundation

final class ProductDetailsPresenter {
    // MARK: - Properties
    weak var view: ProductDetailsViewController?
    private let storage: MainStorage

    private var item: Item?
    private var order: Order?
    private var toppings: [Topping] = []

    var onCartButtonTapped: ( () -> Void )?
    var onDismissButtonTapped: ( () -> Void )?
    var onShowPopupVC: ( (CpfcPopupView) -> Void)?

    // MARK: - Init
    init(storage: MainStorage) {
        self.storage = storage
    }
}

// MARK: - Methods
extension ProductDetailsPresenter {
    func viewDidLoad() {
        fetchData()
    }

    // При нажатии на кнопку корзины мы формируем заказ, добавляем позицию в заказ и отрабатываем замыкания
    func cartButtonTapped() {
        guard let itemToCart = configureCart() else { return }
        storage.addItemToCart(itemToCart)
        onCartButtonTapped?()
        onDismissButtonTapped?()
    }

    // Когда меняются значения на сегментах (вес), то мы обновляем на вью вес товара и цену товара
    func itemSegmentValueChanged(_ index: Int) {
        guard let productDetails = item?.itemSize.getWeightAndPriceViaIndex(index) else { print("We have some problems here"); return }
        view?.updateInfoAndCart(productDetails)
    }

    func showPopupVC(_ popupVC: CpfcPopupView) {
        onShowPopupVC?(popupVC)
    }

    private func configureCart() -> CartItem? {
        guard let item else { return nil}
        let chosenSize = getCorrectSize()
        let chosenDough = getCorrectDough()
        let weight = item.getWeight(size: chosenSize)
        let price = item.getPrice(size: chosenSize)
        let isOneSize = item.hasOneSize()

        let positionToAddToCart = CartItem(item: item, chosenSize: chosenSize, chosenDough: chosenDough, weight: weight, price: price, isOneSize: isOneSize)
        return positionToAddToCart
    }

    // Если есть размер oneSize, то берем его, если нет - выбранный размер
    private func getCorrectSize() -> Size {
        guard let item else { return .oneSize }
        guard let chosenSize = view?.getChosenSize() else { return .oneSize }
        let correctSize = item.hasOneSize() ? .oneSize : chosenSize
        return correctSize
    }

    // Если товар - пицца, то берем тесто, если нет - ничего
    private func getCorrectDough() -> Dough? {
        guard let item else { return nil }
        guard let chosenDough = view?.getChosenDough() else { return nil }
        let correctDough = item.category == .pizza ? chosenDough : nil
        return correctDough
    }

    private func getCorrectWeight() -> Int {
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

// MARK: - Fetch Data
private extension ProductDetailsPresenter {
    func fetchData() {
        fetchSelectedItem()
        fetchToppings()
    }

    func fetchSelectedItem() {
        guard let item = storage.getSelectedItemFromStorage() else { print("No item selected"); return }
        self.item = item
        passSelectedItemToView(item)
        view?.updateUIWithSelectedItem(item)
        showOrHideDoughSegmentView(item)
        showOrHideSizeSegment(item)
        updateWeightAndPriceUI(item)
    }

    private func showOrHideSizeSegment(_ item: Item) {
        if item.itemSize.oneSize != nil {
            view?.hideSizeSegmentView()
        }
    }

    private func updateWeightAndPriceUI(_ item: Item) {
        if item.itemSize.oneSize != nil {
            guard let weight = item.itemSize.oneSize?.weight else { return }
            guard let price = item.itemSize.oneSize?.price else { return }
            view?.updateWeightAndPriceUI(weight, price)
        }
    }

    // Решаем показывать или нет сегмент с тестом (если товар не пицца, то показывать тесто не надо)
    private func showOrHideDoughSegmentView(_ item: Item) {
        let isPizza = item.category == .pizza
        if !isPizza {
            view?.hideDoughSegmentView()
        }
    }

    func passSelectedItemToView(_ item: Item) {
        view?.passSelectedItemToView(item)
    }

    // Загружаем ВСЕ начинки
    func fetchToppings() {
        filterToppings()
    }

    // Отбираем только нужные нам начинки и отправляем данные о топпингах дальше ко вью
    func filterToppings() {
        guard let toppings = item?.toppings else { return }
        self.toppings = toppings
        view?.passToppingsToView(toppings)
    }
}
