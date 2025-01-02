import Foundation
import Combine

// Enum, который перечисляет действия viewModel
enum DeliveryViewModelAction {
    case dismissButtonTapped
    case addressCellTapped
    case deliveryTimeSelected(String)
    case paymentMethodCellTapped
    case payButtonTapped
    case newAddressChosen(String)
}

final class DeliveryViewModel: DeliveryViewModelProtocol {

    // MARK: - Published properties
    @Published private var preferredPaymentMethod: PaymentMethod = .cbp
    @Published private var mainAddressName: String?
    @Published private var cartPrice: Int = 0

    var mainAddressPublisher: Published<String?>.Publisher { $mainAddressName }
    var preferredPaymentMethodPublisher: Published<PaymentMethod>.Publisher { $preferredPaymentMethod }
    var cartPricePublisher: Published<Int>.Publisher { $cartPrice }

    // MARK: - Other properties
    var onDismissButtonTapped: (() -> Void)?
    var onShowChooseAddress: (() -> Void)?
    var onShowChoosePaymentMethod: (() -> Void)?
    var onShowFinalVC: (() -> Void)?

    private let storageService: DataStorageService
    private let storage: DeliveryStorage

    // MARK: - Init
    init(storageService: DataStorageService, storage: DeliveryStorage) {
        self.storageService = storageService
        self.storage = storage
    }
}

// MARK: - DeliveryPresenterProtocol
extension DeliveryViewModel  {
    // Загружаем данные из хранилища
    func initialize() {
        fetchData()
    }

    func sendAction(_ action: DeliveryViewModelAction) {
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

// MARK: - Supporting methods
private extension DeliveryViewModel {
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

    // Отправляет в UserDefaults инфу, что есть активный заказ
    func setActiveOrderToUserDefaults(_ order: Order) {
        UserDefaults.standard.sendOrder(order)
    }
}

// MARK: - Fetch Data
private extension DeliveryViewModel {
    func fetchData() {
        fetchAddresses()
        fetchPreferredPaymentMethod()
        fetchOrderDetails()
    }

    // Получаем адреса и обновляем таблицу с главным адресом
    func fetchAddresses() {
        mainAddressName = storage.getMainAddressName()
    }

    // Получаем выбранный способ оплаты и обновляем таблицу со способами и кнопку оплаты
    func fetchPreferredPaymentMethod() {
        preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
    }

    // Получаем общую сумму заказа и обновляем кнопку
    func fetchOrderDetails() {
        cartPrice = storageService.getTotalOrderPrice()
    }
}
