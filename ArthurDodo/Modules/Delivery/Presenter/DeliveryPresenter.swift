import Foundation

final class DeliveryPresenter {
    weak var view: DeliveryVC?

    // MARK: - Other properties
    private var preferredPaymentMethod: PaymentMethod = .cbp

    private let storageService: DataStorage
    private let storage: DeliveryStorage

    var onDismissButtonTapped: (() -> Void)?
    var onShowChooseAddress: (() -> Void)?
    var onShowChoosePaymentMethod: (() -> Void)?
    var onShowFinalVC: (() -> Void)?

    init(storageService: DataStorage, storage: DeliveryStorage) {
        self.storageService = storageService
        self.storage = storage
    }

    func viewDidLoad() {
        fetchData()
    }
}

extension DeliveryPresenter {
    func sendNewAddressToStorage(_ addressName: String) {
        storageService.setNewMainAddress(addressName)
    }

    func deliveryTimeSelected(_ time: String) {
        storage.setDeliveryTime(time: time)
    }

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
        view?.updateUI(preferredPaymentMethod)
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

