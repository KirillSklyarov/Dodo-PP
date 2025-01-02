import Foundation

protocol AddNewAddressViewProtocol: AnyObject {
    func getViewModel() -> any AddNewAddressVMProtocol
    func showMainAddressOnMap(_ mainAddress: Address?)
    func updateUIWithData(_ mainAddress: Address?)
}
