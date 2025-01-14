import Foundation

protocol EditAddressViewControllerOutput: BaseViewControllerOutput where ActionType == EditAddressAction {

    var coordinatorEventHandler: ((EditAddressCoordinatorEvent) -> Void)? { get set }
}

enum EditAddressAction {
    case saveButtonTapped
    case dismissButtonTapped
    case mapIsMoving(String)
}

enum EditAddressCoordinatorEvent {
    case dismissModule
    case addressSaved
    case showError
}

final class EditAddressPresenter {

    // MARK: - Other properties
    private var addressToEdit: Address?

    var coordinatorEventHandler: ((EditAddressCoordinatorEvent) -> Void)?

    private let storage: AddressStorage

    weak var view: (any EditAddressViewControllerInput)?

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }
}

// MARK: - EditAddressViewControllerOutput
extension EditAddressPresenter: EditAddressViewControllerOutput {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        view?.showLoading()
        fetchData()
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : setErrorState()
    }

    func sendAction(_ action: EditAddressAction) {
        switch action {
        case .saveButtonTapped: saveButtonTapped()
        case .dismissButtonTapped: dismissButtonTapped()
        case .mapIsMoving(let newShortAddress): changeAddressWhileMovingMap(newShortAddress)
        }
    }
}

// MARK: - Supporting methods
private extension EditAddressPresenter {
    // Забираем редактируемый адрес из хранилища
    func fetchData() {
        addressToEdit = storage.getEditingAddress()
    }

    // Когда юзер двигает карту, то мы обновляем в таблице короткий адрес
    func changeAddressWhileMovingMap(_ newShortAddress: String) {
        addressToEdit?.cityStreetHouse = newShortAddress
        guard let addressToEdit else { return }
        view?.updateShortAddress(addressToEdit)
    }

    // Когда юзер нажимает кнопку "сохранить", то мы сохраняем новый адрес в хранилище и через координатор закрываем окно
    func saveButtonTapped() {
        guard let addressToEdit else { return }
        storage.updateAddressesAfterEdition(correctAddress: addressToEdit)
        coordinatorEventHandler?(.addressSaved)
    }

    func dismissButtonTapped() {
        coordinatorEventHandler?(.dismissModule)
    }

    func isDataValid() -> Bool {
        return addressToEdit != nil
    }

    func updateView() {
        guard let addressToEdit else { return }
        view?.configure(with: addressToEdit)
    }

    func setErrorState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            view?.showError()
            coordinatorEventHandler?(.showError)
        }
    }
}

