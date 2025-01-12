import Foundation
import Combine

enum ChooseAddressViewModelAction {
    case dismissButtonTapped
    case addressCellTapped(String)
    case editAddressCellTapped(IndexPath)
    case addNewAddressButtonTapped
}

final class ChooseAddressVM {

    // MARK: - Properties
    @Published private var addresses: [Address]?

    var addressesPublisher: Published<[Address]?>.Publisher { $addresses }

    var onAddressCellTapped: ((String) -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onEditAddressCellTapped: ( (Address) -> Void)?
    var onShowAddNewAddress: (() -> Void)?

    private let storage: DeliveryStorage
    private let storageService: DataStorageService

    // MARK: - Init
    init(storage: DeliveryStorage, storageService: DataStorageService) {
        self.storage = storage
        self.storageService = storageService
    }
}

// MARK: - ChooseAddressVMProtocol
extension ChooseAddressVM: ChooseAddressViewModelProtocol {
    func loadData() {
        fetchData()
    }

    func sendAction(_ action: ChooseAddressViewModelAction) {
        switch action {
        case .dismissButtonTapped: dismissButtonTapped()
        case .addressCellTapped(let addressName): addressCellTapped(addressName)
        case .editAddressCellTapped(let indexPath): editAddressCellTapped(indexPath)
        case .addNewAddressButtonTapped: addNewAddressButtonTapped()
        }
    }
}

// MARK: - Fetch Data
private extension ChooseAddressVM {
    // Получаем данные об адресе
    func fetchData() {
        getAddressesFromStorage()
    }

    // Получаем данные об адресе из хранилища и обновляем таблицу
    func getAddressesFromStorage() {
        addresses = storageService.getAllAddresses()
    }
}

// MARK: - Supporting methods
private extension ChooseAddressVM {
    func addressCellTapped(_ addressName: String) {
        onAddressCellTapped?(addressName)
        onDismissButtonTapped?()
    }

    func editAddressCellTapped(_ indexPath: IndexPath) {
        guard let address = addresses?[indexPath.row] else { print("Address not found"); return }
        onEditAddressCellTapped?(address)
    }

    func addNewAddressButtonTapped() {
        onShowAddNewAddress?()
    }

    func dismissButtonTapped() {
        onDismissButtonTapped?()
    }
}
