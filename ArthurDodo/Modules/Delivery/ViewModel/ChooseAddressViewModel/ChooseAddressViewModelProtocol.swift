import Foundation

protocol ChooseAddressViewModelProtocol: AnyObject {
    func initialize()
    func addressCellTapped(_ addressName: String)
    func editAddressCellTapped(_ indexPath: IndexPath)
    func addNewAddressButtonTapped()
    func dismissButtonTapped()

    var addressesPublisher: Published<[Address]?>.Publisher { get }

    var onAddressCellTapped: ((String) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onEditAddressCellTapped: ( (Address) -> Void)? { get set }
    var onShowAddNewAddress: (() -> Void)? { get set }

}
