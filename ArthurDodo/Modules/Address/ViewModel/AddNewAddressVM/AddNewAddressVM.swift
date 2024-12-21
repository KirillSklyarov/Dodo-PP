import Foundation
import Combine

final class AddNewAddressVM: AddNewAddressVMProtocol {

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
extension AddNewAddressVM {
    func initialize() {
        fetchData()
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
