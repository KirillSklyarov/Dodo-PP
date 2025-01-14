import UIKit

protocol AddressModuleFactoryProtocol: BaseModuleFactory where Module == AddressModule, ErrorType == AddressError {

}

enum AddressModule {
    case address
    case addNewAddress
    case editAddress
}

enum AddressError {
    case address
    case addressToEdit
    case addNewAddress
}

// Класс фабрика экранов отвечает за создание экранов
final class AddressModuleFactory {
    // MARK: - Properties
    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }
}

// MARK: - Methods
extension AddressModuleFactory: AddressModuleFactoryProtocol {
    // Создаем модули
    func makeModule(for module: AddressModule) -> UIViewController {
        switch module {
        case .address: return makeAddressModule()
        case .addNewAddress: return makeAddNewAddressScreen()
        case .editAddress: return makeEditAddressScreen()
        }
    }

    // Создаем алёрты с ошибками
    func makeErrorAlert(for errorAlert: AddressError, completion: (() -> Void)?) -> UIAlertController {
        switch errorAlert {
        case .address: return makeAddressErrorAlert(completion: completion)
        case .addressToEdit: return makeAddressToEditErrorAlert(completion: completion)
        case .addNewAddress: return makeAddNewAddressErrorAlert(completion: completion)
        }
    }
}

// MARK: - Creating modules
private extension AddressModuleFactory {
    func makeAddressModule() -> AddressViewController {
        let configurator = AddressConfigurator(storage: storage)
        return configurator.configure()
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        let configurator = AddNewAddressConfigurator(storage: storage)
        return configurator.configure()
    }

    func makeEditAddressScreen() -> EditAddressViewController {
        let configurator = EditAddressConfigurator(storage: storage)
        return configurator.configure()
    }
}

// MARK: - Creating error alerts
private extension AddressModuleFactory {
    func makeAddressErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.address) {
            completion?()
        }
    }

    func makeAddressToEditErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.addressToEdit) {
            completion?()
        }
    }

    func makeAddNewAddressErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.addNewAddress) {
            completion?()
        }
    }
}
