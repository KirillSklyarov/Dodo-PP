import Foundation

protocol ChooseAddressViewModelProtocol: AnyObject {
    func initialize()
    func sendAction(_ action: ChooseAddressViewModelAction)

    var addressesPublisher: Published<[Address]?>.Publisher { get }

    var onAddressCellTapped: ((String) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onEditAddressCellTapped: ( (Address) -> Void)? { get set }
    var onShowAddNewAddress: (() -> Void)? { get set }
}
