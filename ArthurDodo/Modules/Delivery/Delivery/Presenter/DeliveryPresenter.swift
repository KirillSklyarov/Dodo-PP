import Foundation

// Enum, который перечисляет действия viewModel
enum DeliveryPresenterAction {
    case dismissButtonTapped
    case addressCellTapped
    case deliveryTimeSelected(String)
    case paymentMethodCellTapped
    case payButtonTapped
    case newAddressChosen(String)
}

protocol DeliveryViewControllerOutput: BaseViewControllerOutput where ActionType ==  DeliveryPresenterAction {

    var coordinatorEventHandler: ((DeliveryCoordinatorEvent) -> Void)? { get set }
}

final class DeliveryPresenter {

    // MARK: - Properties
    private var deliveryData = DeliveryData(preferredPaymentMethod: .cbp, mainAddressName: nil, cartPrice: nil)

    var coordinatorEventHandler: ((DeliveryCoordinatorEvent) -> Void)?

    private let storageService: DataStorageService
    private let storage: DeliveryStorage

    weak var view: (any DeliveryViewControllerInput)?

    // MARK: - Init
    init(storageService: DataStorageService, storage: DeliveryStorage) {
        self.storageService = storageService
        self.storage = storage
    }
}

extension DeliveryPresenter: DeliveryViewControllerOutput {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    // Если данные пришли с ошибкой, то выставляем статус ошибки.
    // Если все данные пришли, то мы обновляем экран с полученными данными
    func updateViewWithData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            isDataValid() ? updateUI() : setErrorState()
        }
    }

    // Отрабатываем действия от view
    func sendAction(_ action: DeliveryPresenterAction) {
        switch action {
        case .dismissButtonTapped: dismissButtonTapped()
        case .addressCellTapped: addressCellTapped()
        case .deliveryTimeSelected(let time): deliveryTimeSelected(time)
        case .paymentMethodCellTapped: paymentMethodCellTapped()
        case .payButtonTapped: payButtonTapped()
        case .newAddressChosen(let addressName): sendNewAddressToStorage(addressName)
        }
    }
}

// MARK: - Fetch Data
extension DeliveryPresenter  {
    // Загружаем данные из хранилища
    func loadData() {
        view?.showLoading()
        fetchData()
        updateViewWithData()
    }

    func fetchData() {
        fetchAddresses()
        fetchPreferredPaymentMethod()
        fetchOrderDetails()
    }

    // Получаем адреса и обновляем таблицу с главным адресом
    func fetchAddresses() {
        let mainAddressName = storage.getMainAddressName()
        deliveryData.mainAddressName = mainAddressName
    }

    // Получаем выбранный способ оплаты и обновляем таблицу со способами и кнопку оплаты
    func fetchPreferredPaymentMethod() {
        let preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
        deliveryData.preferredPaymentMethod = preferredPaymentMethod
    }

    // Получаем общую сумму заказа и обновляем кнопку
    func fetchOrderDetails() {
        let cartPrice = storageService.getTotalOrderPrice()
        deliveryData.cartPrice = cartPrice
    }
}

// MARK: - Supporting methods
private extension DeliveryPresenter {
    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isDataValid() -> Bool {
        deliveryData.isValid
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        coordinatorEventHandler?(.showDeliveryErrorAlertModule)
        view?.showError()
    }

    // Обновляем view с полученными данными
    func updateUI() {
        view?.configure(with: deliveryData)
    }

    // Отправляем новый главный адрес в хранилище
    func sendNewAddressToStorage(_ addressName: String) {
        storageService.setNewMainAddress(addressName)
    }

    // Отправляем время доставки в хранилище
    func deliveryTimeSelected(_ time: String) {
        storage.setDeliveryTime(time: time)
    }

    // Отрабатываем нажатие на закрытие окна
    func dismissButtonTapped() {
        coordinatorEventHandler?(.dismissModule)
    }

    // Отрабатываем нажатие на выбор метода оплаты
    func paymentMethodCellTapped() {
        coordinatorEventHandler?(.showChoosePaymentMethod)
    }

    // Отрабатываем нажатие на выбор адреса доставки
    func addressCellTapped() {
        coordinatorEventHandler?(.showChooseAddress)
    }

    // Отрабатываем нажатие на кнопку оплаты. Сначала формируем заказ, потом в UserDefaults сохраняем активный заказ и вызываем замыкание показать финальный экран
    func payButtonTapped() {
        storage.configureOrder()
        guard let order = storage.getOrderFromStorage() else { print("We have no order"); return }
        setActiveOrderToUserDefaults(order)
        coordinatorEventHandler?(.showFinal)
    }

    // Отправляет в UserDefaults инфу, что есть активный заказ
    func setActiveOrderToUserDefaults(_ order: Order) {
        UserDefaults.standard.sendOrder(order)
    }
}
