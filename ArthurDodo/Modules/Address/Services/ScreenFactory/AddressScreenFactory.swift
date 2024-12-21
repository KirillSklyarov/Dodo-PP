import UIKit

protocol AddressScreenFactoryProtocol: AnyObject {
    func makeAddressScreen() -> AddressViewController
    func makeAddNewAddressScreen() -> AddNewAddressViewController
    func makeEditAddressScreen() -> EditAddressViewController
}

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
extension AddressScreenFactory: AddressScreenFactoryProtocol {
    func makeAddressScreen() -> AddressViewController {
        let viewModel = AddressViewModel(storage: storage)
        let view = AddressViewController(viewModel: viewModel)
        return view
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        let viewModel = AddNewAddressVM(storage: storage)
        let view = AddNewAddressViewController(viewModel: viewModel)
        return view
    }

    func makeEditAddressScreen() -> EditAddressViewController {
        let presenter = EditAddressPresenter(storage: storage)
        let view = EditAddressViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
