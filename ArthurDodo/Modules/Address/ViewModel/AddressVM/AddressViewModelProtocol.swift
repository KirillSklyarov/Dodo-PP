import Combine

protocol AddressViewModelProtocol {
    func initialize()
    func sendAction(_ action: AddressAction)

    var addressesPublisher: Published<[Address]>.Publisher { get }
    var mainAddressPublisher: Published<Address?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowEditAddressVC: (() -> Void)? { get set }
    var onShowAddNewAddressVC: (() -> Void)? { get set }
    var onDeliveryButtonTapped: (() -> Void)? { get set }
}
