import Foundation
import Combine

protocol EditAddressVMProtocol: AnyObject {
    func changeAddressWhileMovingMap(_ newShortAddress: String)

    func initialize()
    func saveButtonTapped()
    func dismissButtonTapped() 

    var addressToEditPublisher: Published<Address?>.Publisher { get }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onSaveButtonTapped: (() -> Void)? { get set }
}

final class EditAddressVM: EditAddressVMProtocol {

    // MARK: - Other properties
    @Published var addressToEdit: Address?

    var addressToEditPublisher: Published<Address?>.Publisher { $addressToEdit }

    var onDismissButtonTapped: (() -> Void)?
    var onSaveButtonTapped: (() -> Void)?

    private let storage: AddressStorage


    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }

    func initialize() {
        fetchData()
    }
}

// MARK: - EditAddressPresenterProtocol
extension EditAddressVM {
    func changeAddressWhileMovingMap(_ newShortAddress: String) {
        addressToEdit?.cityStreetHouse = newShortAddress
    }

    func saveButtonTapped() {
        guard let addressToEdit else { return }
        storage.updateAddressesAfterEdition(correctAddress: addressToEdit)
        onSaveButtonTapped?()
    }

    func dismissButtonTapped() {
        onDismissButtonTapped?()
    }
}

// MARK: - Supporting methods
private extension EditAddressVM {
    // Забираем редактируемый адрес из хранилища
    func fetchData() {
        addressToEdit = storage.getEditingAddress()
    }
}

