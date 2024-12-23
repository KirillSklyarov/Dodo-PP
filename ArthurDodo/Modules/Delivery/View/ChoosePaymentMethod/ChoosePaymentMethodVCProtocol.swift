import Foundation

protocol ChoosePaymentMethodVCProtocol: AnyObject {
    func getViewModel() -> ChoosePaymentMethodVMProtocol
    func updateUI(_ preferredPaymentMethod: PaymentMethod)
}
