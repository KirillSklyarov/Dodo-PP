import UIKit

// Класс фабрика экранов отвечает за создание экранов
final class AddressScreenFactory {
    // MARK: - Properties
    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }
}

// MARK: - Methods
extension AddressScreenFactory {
    func makeAddressScreen() -> AddressViewController {
        let presenter = AddressPresenter(storage: storage)
        let view = AddressViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        let presenter = AddNewAddressPresenter(storage: storage)
        let view = AddNewAddressViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeEditAddressScreen() -> EditAddressViewController {
        let presenter = EditAddressPresenter(storage: storage)
        let view = EditAddressViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}

