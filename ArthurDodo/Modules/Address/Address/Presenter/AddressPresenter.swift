import Foundation

enum AddressAction {
    case dismissButtonTapped
    case editAddressTapped(Address)
    case addressSelected(Address)
    case addNewAddressTapped
    case deliveryButtonTapped
}

enum AddressViewControllerEvent {
    case dismissModule
    case showEditAddressVC
    case showAddNewAddressVC
    case deliveryButtonTapped
}

protocol AddressViewControllerOutput: BaseViewControllerOutput where ActionType == AddressAction, CoordinatorEvent == AddressViewControllerEvent {
    func getMainAddress() -> Address?
}

final class AddressPresenter {

    // MARK: - Properties
    private var addresses: [Address]?
    private var mainAddress: Address?

    var coordinatorEventHandler: ((AddressViewControllerEvent) -> Void)?

    private let storage: AddressStorage
    weak var view: (any AddressViewControllerInput)?

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }

    deinit {
        print("AddressPresenter deinit")
    }
}

// MARK: - AddressViewControllerOutput
extension AddressPresenter: AddressViewControllerOutput {
    // Как получили сведения, что view загружено, то выставляем стартовое состояние, загружаем данные и делаем проверку данных
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        view?.showLoading()
        fetchData()
    }

    // Если данные OK, то обновляем view, если нет - ставим состояние Error
    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : setErrorState()
    }

    // Отрабатываем действия юзера
    func sendAction(_ action: AddressAction) {
        switch action {
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .editAddressTapped(let address): editAddressTapped(address)
        case .addNewAddressTapped: showAddNewAddressVC()
        case .deliveryButtonTapped: deliveryButtonTapped()
        case .addressSelected(let address): addressTapped(address)
        }
    }

    // Отдаем главный адрес
    func getMainAddress() -> Address? {
        mainAddress
    }
}

// MARK: - Fetch data from Network
private extension AddressPresenter {
    // Получаем данные из хранилища
    func fetchData() {
        addresses = storage.getAddresses()
        mainAddress = storage.getMainAddress()
    }
}

// MARK: - Supporting methods
extension AddressPresenter {
    func isDataValid() -> Bool {
        return addresses != nil
    }

    func updateView() {
        guard let addresses else { return }
        view?.configure(with: addresses)
    }

    func setErrorState() {
        view?.showError()
    }

    // Когда юзер нажал на новый адрес мы показываем его на карте и ставим этот адрес как main
    func addressTapped(_ address: Address) {
        mainAddress = address // Обновляем адрес здесь
        passNewMainAddressToStorage(address) // Устанавливаем новый главный адрес
        view?.showAddressOnMap()
    }

    func passNewMainAddressToStorage(_ address: Address) {
        storage.setNewMainAddress(address.name) // Устанавливаем новые главный адрес
    }

    // При нажатии на кнопку "редактировать адрес" передаем адрес в хранилище и показываем экран редактирования
    func editAddressTapped(_ address: Address) {
        storage.setEditingAddress(address)
        coordinatorEventHandler?(.showEditAddressVC)
    }

    // При нажатии на кнопку "добавить новый адрес" вызываем замыкание для показа нового экрана
    func showAddNewAddressVC() {
        coordinatorEventHandler?(.showAddNewAddressVC)
    }

    // Нажали на кнопку "Доставить сюда"
    func deliveryButtonTapped() {
        coordinatorEventHandler?(.deliveryButtonTapped)
    }
}
