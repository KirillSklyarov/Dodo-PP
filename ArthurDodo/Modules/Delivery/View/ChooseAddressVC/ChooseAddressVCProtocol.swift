import Foundation

protocol ChooseAddressVCProtocol: AnyObject {
    func updateUI(_ addresses: [Address])
    func getViewModel() -> ChooseAddressViewModelProtocol
}
