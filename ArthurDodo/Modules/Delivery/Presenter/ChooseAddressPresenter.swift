import Foundation

protocol ChooseAddressPresenterProtocol: AnyObject {
    func viewDidLoad()
    func addressCellTapped(_ addressName: String)
    func editAddressCellTapped(_ indexPath: IndexPath)
    func addNewAddressButtonTapped()
    func dismissButtonTapped()

    var onAddressCellTapped: ((String) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onEditAddressCellTapped: ( (Address) -> Void)? { get set }
    var onShowAddNewAddress: (() -> Void)? { get set }
}

final class ChooseAddressPresenter {
    weak var view: ChooseAddressVCProtocol?

    // MARK: - Other Properties
    private var addresses: [Address] = []

    private let storage: DeliveryStorage
    private let storageService: DataStorage

    var onAddressCellTapped: ((String) -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onEditAddressCellTapped: ( (Address) -> Void)?
    var onShowAddNewAddress: (() -> Void)?

    init(storage: DeliveryStorage, storageService: DataStorage) {
        self.storage = storage
        self.storageService = storageService
    }
}

// MARK: - ChooseAddressPresenterProtocol
extension ChooseAddressPresenter: ChooseAddressPresenterProtocol {
    func viewDidLoad() {
        fetchData()
    }

    func addressCellTapped(_ addressName: String) {
        onAddressCellTapped?(addressName)
        onDismissButtonTapped?()
    }

    func editAddressCellTapped(_ indexPath: IndexPath) {
        let address = addresses[indexPath.row]
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
private extension ChooseAddressPresenter {
    // Получаем данные об адресе
    func fetchData() {
        getAddressesAndUpdateUI()
    }

    // Получаем данные об адресе из хранилища и обновляем таблицу
    func getAddressesAndUpdateUI() {
        addresses = storageService.getAllAddresses()
        view?.updateUI(addresses)
    }
}
