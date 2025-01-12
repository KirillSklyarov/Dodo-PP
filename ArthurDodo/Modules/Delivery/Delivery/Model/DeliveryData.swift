import Foundation

struct DeliveryData {
    var preferredPaymentMethod: PaymentMethod
    var mainAddressName: String?
    var cartPrice: Int?
}

extension DeliveryData {
    var isValid: Bool {
        return mainAddressName != nil &&
               cartPrice != nil
    }
}
