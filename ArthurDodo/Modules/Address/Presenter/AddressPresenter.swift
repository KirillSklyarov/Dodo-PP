import Foundation

protocol AddressPresenterProtocol: AnyObject {
    func viewDidLoad()
    func addressTapped(_ address: Address)
    func setEditingAddressToStorage(_ address: Address)
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowEditAddressVC: (() -> Void)? { get set }
    var onShowAddNewAddressVC: (() -> Void)? { get set }
    var onDeliveryButtonTapped: (() -> Void)? { get set }
}

final class AddressPresenter: AddressPresenterProtocol {

    // MARK: - View
    weak var view: AddressViewProtocol?

    // MARK: - Properties
    var onDismissButtonTapped: (() -> Void)?
    var onShowEditAddressVC: (() -> Void)?
    var onShowAddNewAddressVC: (() -> Void)?
    var onDeliveryButtonTapped: (() -> Void)?

    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }

    func viewDidLoad() {
        fetchData()
    }
}

// MARK: - Fetch data from Network
extension AddressPresenter {
    // Получаем данные из хранилища
    func fetchData() {
        let addresses = storage.getAddresses()
        let mainAddress = storage.getMainAddress()
        updateAddress(addresses)
        showAddressOnMap(mainAddress)
    }

    // Когда юзер нажал на новый адрес мы показываем его на карте и ставим этот адрес как main
    func addressTapped(_ address: Address) {
        passNewMainAddressToStorage(address) // Устанавливаем новый главный адрес
        view?.showAddressOnMap(address) // Показываем новый адрес на карте
    }

    func passNewMainAddressToStorage(_ address: Address) {
        storage.setNewMainAddress(address.name) // Устанавливаем новые главный адрес
    }

    // Передаем все адреса на вью
    func updateAddress(_ addresses: [Address]?) {
        guard let addresses else { print("We have no addresses"); return }
        view?.updateAddress(addresses)
    }

    // Показываем главный адрес на карте
    func showAddressOnMap(_ mainAddress: Address?) {
        guard let mainAddress else { print("We have no main address"); return }
        view?.showAddressOnMap(mainAddress)
    }

    func setEditingAddressToStorage(_ address: Address) {
        storage.setEditingAddress(address)
        onShowEditAddressVC?()
    }
}


// Старый метод, не удаляем без проверки текущей реализации
// func getAddressFromStorage() {
//    let dispatchGroup = DispatchGroup()
//
//    // Сначала получаем все данные
//    dispatchGroup.enter()
//    getAddressesAndMainAddress {
//        dispatchGroup.leave()
//    }
//
//    // Потом уже передаем адреса на карту
//    dispatchGroup.notify(queue: .main) { [weak self] in
//        guard let self else { print("We have no self"); return }
//        updateAddress()
//        guard let mainAddress else { print("We have no main address"); return }
//        view?.showAddressOnMap(mainAddress)
//    }
//}

// Забираем данные из хранилища
//func getAddressesAndMainAddress(completion: (() -> Void)?) {
//    addresses = storage.getAddresses()
//    mainAddress = storage.getMainAddress()
//    completion?()
//}
