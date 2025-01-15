import Foundation

protocol AddNewAddressViewControllerOutput: BaseViewControllerOutput where ActionType == AddNewAddressAction {

    var coordinatorEventHandler: ((AddNewAddressCoordinatorEvent) -> Void)? { get set }
}

enum AddNewAddressAction {
    case dismissButtonTapped
    case saveNewAddressButtonTapped(Address)
}

enum AddNewAddressCoordinatorEvent {
    case dismissModule
    case addedNewAddress
    case addNewAddressError
}

final class AddNewAddressPresenter {

    // MARK: - Properties
    private var mainAddress: Address?

    var coordinatorEventHandler: ((AddNewAddressCoordinatorEvent) -> Void)?

    private let storage: AddressStorage

    weak var view: (any AddNewAddressViewControllerInput)?

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }
}

// MARK: - AddNewAddressViewControllerOutput
extension AddNewAddressPresenter: AddNewAddressViewControllerOutput {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    func loadData() {
        view?.showLoading()
        fetchData()
        checkDataAndUpdateView()
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : setErrorState()
    }

    func sendAction(_ action: AddNewAddressAction) {
        switch action {
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .saveNewAddressButtonTapped(let newAddress): saveNewAddressButtonTapped(newAddress)
        }
    }
}

// MARK: - Fetch Data
private extension AddNewAddressPresenter {
    // Запрашиваем основной адрес у хранилища и показываем его на карте
    func fetchData() {
        mainAddress = storage.getMainAddress()
    }
}

// MARK: - Supporting methods
private extension AddNewAddressPresenter {
    func isDataValid() -> Bool {
        return mainAddress != nil
    }

    func updateView() {
        guard let mainAddress else { return }
        view?.configure(with: mainAddress)
    }

    func setErrorState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            view?.showError()
            coordinatorEventHandler?(.addNewAddressError)
        }
    }

    // Отрабатываем нажатие на кнопку "Доставить сюда" (добавляем адрес в список адресов)
    func saveNewAddressButtonTapped(_ newAddress: Address) {
        storage.addAddress(newAddress)
        coordinatorEventHandler?(.addedNewAddress)
    }
}
