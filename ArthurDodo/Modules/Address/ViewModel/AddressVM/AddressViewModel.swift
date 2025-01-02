import Foundation
import Combine

final class AddressViewModel {

    // MARK: - Properties
    @Published var addresses: [Address] = []
    @Published var mainAddress: Address?

    var addressesPublisher: Published<[Address]>.Publisher { $addresses }
    var mainAddressPublisher: Published<Address?>.Publisher { $mainAddress }

    var onDismissButtonTapped: (() -> Void)?
    var onShowEditAddressVC: (() -> Void)?
    var onShowAddNewAddressVC: (() -> Void)?
    var onDeliveryButtonTapped: (() -> Void)?

    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }
}

// MARK: - Fetch data from Network
private extension AddressViewModel {
    // Получаем данные из хранилища
    func fetchData() {
        addresses = storage.getAddresses()
        mainAddress = storage.getMainAddress()
    }
}

// MARK: - AddressViewModelProtocol
extension AddressViewModel: AddressViewModelProtocol {
    // Стартовый метод
    func initialize() {
        fetchData()
    }

    func sendAction(_ action: AddressAction) {
        switch action {
        case .dismissButtonTapped: onDismissButtonTapped?()
        case .editAddressTapped: onShowEditAddressVC?()
        case .addNewAddressTapped: onShowAddNewAddressVC?()
        case .deliveryButtonTapped: onDeliveryButtonTapped?()
        case .addressSelected(let address): addressTapped(address)
        }
    }

    // Когда юзер нажал на новый адрес мы показываем его на карте и ставим этот адрес как main
    func addressTapped(_ address: Address) {
        mainAddress = address // Обновляем адрес здесь
        passNewMainAddressToStorage(address) // Устанавливаем новый главный адрес
    }

    func passNewMainAddressToStorage(_ address: Address) {
        storage.setNewMainAddress(address.name) // Устанавливаем новые главный адрес
    }

    // При нажатии на кнопку "редактировать адрес" передаем адрес в хранилище и показываем экран редактирования
    func editAddressTapped(_ address: Address) {
        storage.setEditingAddress(address)
        onShowEditAddressVC?()
    }

    // При нажатии на кнопку "добавить новый адрес" вызываем замыкание для показа нового экрана
    func showAddNewAddressVC() {
        onShowAddNewAddressVC?()
    }

    func deliveryButtonTapped() {
        onDeliveryButtonTapped?()
    }
}


// Передаем все адреса на вью
//    func updateAddress(_ addresses: [Address]?) {
//        guard let addresses else { print("We have no addresses"); return }
//        view?.updateAddress(addresses)
//    }

// Показываем главный адрес на карте
//    func showAddressOnMap(_ mainAddress: Address?) {
//        guard let mainAddress else { print("We have no main address"); return }
//        view?.showAddressOnMap(mainAddress)
//    }
