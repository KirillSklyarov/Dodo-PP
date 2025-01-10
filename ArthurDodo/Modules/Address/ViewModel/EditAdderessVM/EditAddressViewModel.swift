import Foundation
import Combine

protocol EditAddressViewModelProtocol: BaseViewControllerOutputOLD where ActionType == EditAddressAction {

    var addressToEditPublisher: Published<Address?>.Publisher { get }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onSaveButtonTapped: (() -> Void)? { get set }
}

enum EditAddressAction {
    case saveButtonTapped
    case dismissButtonTapped
    case mapIsMoving(String)
}

final class EditAddressViewModel {

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
}

// MARK: - EditAddressViewModelProtocol
extension EditAddressViewModel: EditAddressViewModelProtocol {
    func initialize() {
        fetchData()
    }

    func sendAction(_ action: EditAddressAction) {
        switch action {
        case .saveButtonTapped: saveButtonTapped()
        case .dismissButtonTapped: dismissButtonTapped()
        case .mapIsMoving(let newShortAddress): changeAddressWhileMovingMap(newShortAddress)

        }
    }

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
private extension EditAddressViewModel {
    // Забираем редактируемый адрес из хранилища
    func fetchData() {
        addressToEdit = storage.getEditingAddress()
    }
}

