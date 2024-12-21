//import Foundation
//
//protocol EditAddressPresenterProtocol: AnyObject {
//    func viewDidLoad()
//    func saveButtonTapped()
//    func changeAddressWhileMovingMap(_ newShortAddress: String)
//    func dismissButtonTapped()
//
//    var onDismissButtonTapped: (() -> Void)? { get set }
//    var onSaveButtonTapped: (() -> Void)? { get set }
//}
//
//final class EditAddressPresenter {
//    weak var view: EditAddressViewProtocol?
//
//    // MARK: - Other properties
//    var addressToEdit: Address?
//    private let storage: AddressStorage
//
//    var onDismissButtonTapped: (() -> Void)?
//    var onSaveButtonTapped: (() -> Void)?
//
//    // MARK: - Init
//    init(storage: AddressStorage) {
//        self.storage = storage
//        getEditAddressFromStorage()
//    }
//
//    func viewDidLoad() {
//        updateAddress()
//    }
//}
//
//// MARK: - EditAddressPresenterProtocol
//extension EditAddressPresenter: EditAddressPresenterProtocol {
//    func changeAddressWhileMovingMap(_ newShortAddress: String) {
//        addressToEdit?.cityStreetHouse = newShortAddress
//        view?.updateShortAddress(newShortAddress)
//    }
//
//    func saveButtonTapped() {
//        guard let addressToEdit else { return }
//        storage.updateAddressesAfterEdition(correctAddress: addressToEdit)
//        onSaveButtonTapped?()
//    }
//
//    func dismissButtonTapped() {
//        onDismissButtonTapped?()
//    }
//}
//
//// MARK: - Supporting methods
//private extension EditAddressPresenter {
//    func updateAddress() {
//        if let addressToEdit {
//            view?.updateAddress(addressToEdit)
//        }
//    }
//
//    // Забираем редактируемый адрес из хранилища
//    func getEditAddressFromStorage() {
//        addressToEdit = storage.getEditingAddress()
//    }
//}
