import Foundation

protocol ChooseAddressViewControllerOutput: BaseViewControllerOutput where ActionType == ChooseAddressViewModelAction {

    var coordinatorEventHandler: ((ChooseAddressCoordinatorEvent) -> Void)? { get set }
}

enum ChooseAddressViewModelAction {
    case dismissButtonTapped
    case addressCellTapped(String)
    case editAddressCellTapped(IndexPath)
    case addNewAddressButtonTapped
}

enum ChooseAddressCoordinatorEvent {
    case dismissModule
    case showAddressErrorAlert
    case addressSelected(String)
}

final class ChooseAddressPresenter {

    // MARK: - Properties
    private var addresses: [Address]?

//    var onAddressCellTapped: ((String) -> Void)?
    var onEditAddressCellTapped: ( (Address) -> Void)?
    var onShowAddNewAddress: (() -> Void)?

//    private let router: ChooseAddressRouterInput
    private let storageService: DataStorageService

    weak var view: ChooseAddressViewInput?

    var coordinatorEventHandler: ((ChooseAddressCoordinatorEvent) -> Void)?

    // MARK: - Init
    init(storageService: DataStorageService) {
        self.storageService = storageService
    }
}

// MARK: - ChooseAddressViewOutput
extension ChooseAddressPresenter: ChooseAddressViewControllerOutput {
    func viewLoaded() {
        view?.setInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        view?.showLoading()
        fetchData()
    }

    // Если какие-то данные не получили, то показывает алерт с ошибкой, если все ок, то выставляем статус success
    func checkDataAndUpdateView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            isDataValid() ? updateView() : setErrorState()
        }
    }

    func sendAction(_ action: ChooseAddressViewModelAction) {
        switch action {
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .addressCellTapped(let addressName): addressCellTapped(addressName)
        case .editAddressCellTapped(let indexPath): editAddressCellTapped(indexPath)
        case .addNewAddressButtonTapped: addNewAddressButtonTapped()
        }
    }
}

// MARK: - Fetch Data
private extension ChooseAddressPresenter {
    // Получаем данные об адресе из хранилища и обновляем таблицу
    func fetchData() {
        addresses = storageService.getAllAddresses()
    }

    // Проверяем данные
    func isDataValid() -> Bool {
        return addresses != nil
    }

    // Обновляем view
    func updateView() {
        guard let addresses else { return }
        view?.configure(with: addresses)
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        view?.showError()
        coordinatorEventHandler?(.showAddressErrorAlert)
    }
}

// MARK: - Supporting methods
private extension ChooseAddressPresenter {
    func addressCellTapped(_ addressName: String) {
        coordinatorEventHandler?(.addressSelected(addressName))
    }

    func editAddressCellTapped(_ indexPath: IndexPath) {
        guard let address = addresses?[indexPath.row] else { print("Address not found"); return }
        onEditAddressCellTapped?(address)
    }

    func addNewAddressButtonTapped() {
        onShowAddNewAddress?()
    }
}
