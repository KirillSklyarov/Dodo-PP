import Foundation

protocol DeliveryPresenterProtocol: AnyObject {
    func sendNewAddressToStorage(_ addressName: String)
    func viewDidLoad()
    func dismissButtonTapped()
    func addressCellTapped()
    func deliveryTimeSelected(_ time: String)
    func payButtonTapped()
    func paymentMethodCellTapped()

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowChooseAddress: (() -> Void)? { get set }
    var onShowChoosePaymentMethod: (() -> Void)? { get set }
    var onShowFinalVC: (() -> Void)? { get set }
}

final class DeliveryPresenter {
    weak var view: DeliveryViewProtocol?

    // MARK: - Other properties
    private var preferredPaymentMethod: PaymentMethod = .cbp

    private let storageService: DataStorageService
    private let storage: DeliveryStorage

    var onDismissButtonTapped: (() -> Void)?
    var onShowChooseAddress: (() -> Void)?
    var onShowChoosePaymentMethod: (() -> Void)?
    var onShowFinalVC: (() -> Void)?

    init(storageService: DataStorageService, storage: DeliveryStorage) {
        self.storageService = storageService
        self.storage = storage
    }
}

// MARK: - DeliveryPresenterProtocol
extension DeliveryPresenter: DeliveryPresenterProtocol {
    // Загружаем данные из хранилища
    func viewDidLoad() {
        fetchData()
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
        onDismissButtonTapped?()
    }

    // Отрабатываем нажатие на выбор метода оплаты
    func paymentMethodCellTapped() {
        onShowChoosePaymentMethod?()
    }

    // Отрабатываем нажатие на выбор адреса доставки
    func addressCellTapped() {
        onShowChooseAddress?()
    }

    // Отрабатываем нажатие на кнопку оплаты. Сначала формируем заказ, потом в UserDefaults сохраняем активный заказ и вызываем замыкание показать финальный экран
    func payButtonTapped() {
        storage.configureOrder()
        guard let order = storage.getOrderFromStorage() else { print("We have no order"); return }
        setActiveOrderToUserDefaults(order)
        onShowFinalVC?()
    }
}

// MARK: - Fetch Data
private extension DeliveryPresenter {
    func fetchData() {
        fetchAddresses()
        fetchPreferredPaymentMethod()
        fetchOrderDetails()
    }

    // Получаем адреса и обновляем таблицу с главным адресом
    func fetchAddresses() {
        let mainAddressName = storage.getMainAddressName()
        view?.updateAddressUI(mainAddressName)
    }

    // Получаем выбранный способ оплаты и обновляем таблицу со способами и кнопку оплаты
    func fetchPreferredPaymentMethod() {
        preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
        view?.updatePaymentMethodUI(preferredPaymentMethod)
    }

    // Получаем общую сумму заказа и обновляем кнопку
    func fetchOrderDetails() {
        let totalPrice = storageService.getTotalOrderPrice()
        view?.updateTotalPriceView(totalPrice)
    }
}

// MARK: - Supporting methods
private extension DeliveryPresenter {
    // Отправляет в UserDefaults инфу, что есть активный заказ
    func setActiveOrderToUserDefaults(_ order: Order) {
        UserDefaults.standard.sendOrder(order)
    }
}
