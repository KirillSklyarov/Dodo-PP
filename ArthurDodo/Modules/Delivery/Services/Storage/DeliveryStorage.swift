import Foundation

final class DeliveryStorage {

    var storageService: DataStorageService?

    private lazy var preferredPaymentMethod: PaymentMethod = .cbp
    private var deliveryTime = ""
    private var order: Order?

    var editingAddress: Address? // В этой переменной лежит адрес, который редактируется
    var fetchedUserData: User?

    // MARK: - Init
    //    init(storageService: DataManager) {
    //        self.storageService = storageService
    //    }

    func setStorageService(_ storageService: DataStorageService) {
        self.storageService = storageService
    }

}

extension DeliveryStorage {
    func getMainAddressName() -> String {
        guard let mainAddressName = storageService?.getMainAddress()?.name else { print("Error: No main address"); return ""}
        return mainAddressName
    }

    // Отдаем активный заказ
    func getOrderFromStorage() -> Order? {
        order
    }

    // Принимаем время доставки
    func setDeliveryTime(time: String) {
        deliveryTime = time
    }

    // Формируем заказ (получаем позиции, получаем адрес)
    func configureOrder() {
        guard let orderPositions = castCartToOrder() else { print("OrderPositions is nil"); return }
        guard let address = storageService?.getMainAddress()?.cityStreetHouse else { print("No main address"); return }
        order = Order(position: orderPositions, deliveryAddress: address, deliveryTime: deliveryTime, status: .inProgress)
    }

    // Делаем заказ из корзины (так как формы заказа и корзины отличаются, то нам нужно скастить корзину до заказа)
    private func castCartToOrder() -> [OrderPosition]? {
        let cart = storageService?.getCart()
        guard let cart else { print("Cart is nil"); return nil}
        var orderPositions: [OrderPosition] = []
        for cartItem in cart.items {
            let position = OrderPosition(itemName: cartItem.item.name, size: cartItem.chosenSize, dough: cartItem.chosenDough, weight: cartItem.weight, price: cartItem.price, count: cartItem.count)
            orderPositions.append(position)
        }
        return orderPositions
    }
}

// MARK: - Preferred payment method
extension DeliveryStorage {
    func getPreferredPaymentMethodFromStorage() -> PaymentMethod {
        getPreferredPaymentMethodFromUserDefaults()
        return preferredPaymentMethod
    }

    private func getPreferredPaymentMethodFromUserDefaults() {
        if let preferredMethod = UserDefaults.standard.getPreferredPaymentMethod() {
            if let tempMethod = PaymentMethod.getMethodFrom(preferredMethod) {
                preferredPaymentMethod = tempMethod
            }
        } else {
            preferredPaymentMethod = .cbp
            print("Default payment method = .cbp")
        }
    }
}

// MARK: - CrossStorageProtocol
extension DeliveryStorage: CrossStorageProtocol {
    func getEditingAddress() -> Address? {
        editingAddress
    }

    func updateAddressesAfterEdition(correctAddress: Address) {
        var deleteOldAddress = fetchedUserData?.address.filter { $0.addressId != correctAddress.addressId }
        deleteOldAddress?.append(correctAddress)
        guard let deleteOldAddress else { return }
        fetchedUserData?.address = deleteOldAddress
    }
}
