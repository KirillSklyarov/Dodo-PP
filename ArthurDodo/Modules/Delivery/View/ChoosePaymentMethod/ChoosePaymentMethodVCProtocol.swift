import Foundation

protocol ChoosePaymentMethodVCProtocol: AnyObject {
    func getViewModel() -> any ChoosePaymentMethodVMProtocol
    func updateUI(_ preferredPaymentMethod: PaymentMethod)
}
