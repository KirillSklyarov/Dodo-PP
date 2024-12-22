import Foundation
import Combine

protocol ChooseAddressVMProtocol {
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
extension ChooseAddressVM: ChooseAddressVMProtocol {
    func initialize() {
        fetchData()
    }

    func addressCellTapped(_ addressName: String) {
        storageService.setNewMainAddress(addressName)
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

// MARK: - Fetch Data
private extension ChooseAddressVM {
    // Получаем данные об адресе
    func fetchData() {
        getAddressesFromStorage()
    }

    // Получаем данные об адресе из хранилища и обновляем таблицу
    func getAddressesFromStorage() {
        addresses = storageService.getAllAddresses()
        print("addresses \(addresses)")
    }
}

