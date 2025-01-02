import Combine

protocol AddressViewModelProtocol: BaseViewModelProtocol where ActionType == AddressAction {

    var addressesPublisher: Published<[Address]>.Publisher { get }
    var mainAddressPublisher: Published<Address?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowEditAddressVC: (() -> Void)? { get set }
    var onShowAddNewAddressVC: (() -> Void)? { get set }
    var onDeliveryButtonTapped: (() -> Void)? { get set }
}
