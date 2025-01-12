import UIKit

// Список модулей для Delivery
enum DeliveryModule {
    case delivery
    case chooseAddress
    case choosePaymentMethod
    case editAddress
    case addNewAddress
    case final
}

// Список ошибок для Delivery
enum DeliveryError {
    case deliveryError
}

protocol DeliveryModuleFactoryProtocol: BaseModuleFactory where Module == DeliveryModule, ErrorType == DeliveryError {
}

// Фабрика экранов модуля Доставки и оплаты
final class DeliveryModuleFactory {

    // MARK: - Properties
    private let storage: DeliveryStorage
    private let addressStorage: AddressStorage
    private let storageService: DataStorageService

    // MARK: - Init
    init(storageService: DataManager) {
        self.storage = storageService.deliveryStorage
        self.storageService = storageService.dataStorageService
        self.addressStorage = storageService.addressStorage
    }
}

// MARK: - DeliveryModuleFactoryProtocol
extension DeliveryModuleFactory: DeliveryModuleFactoryProtocol {

    // Метод показывает собирает модули
    func makeModule(for module: DeliveryModule) -> UIViewController {
        switch module {
        case .delivery: return makeDeliveryModule()
        case .chooseAddress: return makeChooseAddressModule()
        case .choosePaymentMethod: return makeChoosePaymentMethodModule()
        case .editAddress: return makeEditAddressModule()
        case .addNewAddress: return makeAddNewAddressModule()
        case .final: return makeFinalModule()
        }
    }

    // Метод показывает собирает ошибки
    func makeErrorAlert(for errorAlert: DeliveryError, completion: (() -> Void)?) -> UIAlertController {
        switch errorAlert {
        case .deliveryError: return makeDeliveryErrorAlert { completion?() }
        }
    }
}

// MARK: - Methods
private extension DeliveryModuleFactory {
    func makeDeliveryModule() -> DeliveryViewController {
        let configurator = DeliveryConfigurator(storage: storage, storageService: storageService)
        return configurator.configure()
    }

    func makeChooseAddressModule() -> ChooseAddressVC {
        let viewModel = ChooseAddressVM(storage: storage, storageService: storageService)
        let view = ChooseAddressVC(viewModel: viewModel)
        return view
    }

    func makeChoosePaymentMethodModule() -> ChoosePaymentMethodVC {
        let viewModel = ChoosePaymentMethodVM(storage: storage)
        let view = ChoosePaymentMethodVC(viewModel: viewModel)
        return view
    }

    func makeEditAddressModule() -> EditAddressViewController {
        let viewModel = EditAddressViewModel(storage: addressStorage)
        let view = EditAddressViewController(viewModel: viewModel)
        return view
    }

    func makeAddNewAddressModule() -> AddNewAddressViewController {
        let viewModel = AddNewAddressVM(storage: addressStorage)
        let view = AddNewAddressViewController(viewModel: viewModel)
        return view
    }

    func makeFinalModule() -> FinalVC {
        let viewModel = FinalViewModel(storageService: storageService)
        let view = FinalVC(viewModel: viewModel)
        return view
    }
}

// MARK: - Errors
private extension DeliveryModuleFactory {
    func makeDeliveryErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.delivery) {
            completion?()
        }
    }
}
