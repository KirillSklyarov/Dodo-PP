import Foundation

protocol AddNewAddressViewProtocol: AnyObject {
    func showMainAddressOnMap(_ mainAddress: Address?)
    func updateUIWithData(_ mainAddress: Address?)
}
