import Foundation
import Combine

enum AddNewAddressAction {
    case dismissButtonTapped
    case saveNewAddressButtonTapped(Address)
}

final class AddNewAddressVM {

    // MARK: - Properties
    @Published private var mainAddress: Address?
    var mainAddressPublisher: Published<Address?>.Publisher { $mainAddress }

    var onDismissButtonTapped: (() -> Void)?
    var onSaveNewAddressButtonTapped: (() -> Void)?

    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }
}

// MARK: - AddNewAddressVMProtocol
extension AddNewAddressVM: AddNewAddressVMProtocol {
    func loadData() {
        fetchData()
    }

    func sendAction(_ action: AddNewAddressAction) {
        switch action {
        case .dismissButtonTapped: onDismissButtonTapped?()
        case .saveNewAddressButtonTapped(let newAddress): saveNewAddressButtonTapped(newAddress)
        }
    }

    // Отрабатываем нажатие на кнопку "Доставить сюда" (добавляем адрес в список адресов)
    func saveNewAddressButtonTapped(_ newAddress: Address) {
        storage.addAddress(newAddress)
        onSaveNewAddressButtonTapped?()
    }
}

// MARK: - Fetch Data
private extension AddNewAddressVM {
    // Запрашиваем основной адрес у хранилища и показываем его на карте
    func fetchData() {
        mainAddress = storage.getMainAddress()
        print(mainAddress?.cityStreetHouse ?? "No address")
    }
}
