import Foundation
import Combine

protocol AddressViewModelProtocol {
    var addressesPublisher: Published<[Address]>.Publisher { get }
    var mainAddressPublisher: Published<Address?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowEditAddressVC: (() -> Void)? { get set }
    var onShowAddNewAddressVC: (() -> Void)? { get set }
    var onDeliveryButtonTapped: (() -> Void)? { get set }

    func initialize()
    func editAddressTapped(_ address: Address)
    func addressTapped(_ address: Address)
    func showAddNewAddressVC()
    func deliveryButtonTapped()
}
