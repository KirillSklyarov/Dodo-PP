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
    case chooseAddress
    case addressToEdit
    case addNewAddress
    case paymentMethod
    case finalError
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
        case .chooseAddress: return makeChooseAddressErrorAlert { completion?() }
        case .paymentMethod: return makePaymentMethodErrorAlert { completion?() }
        case .finalError: return makeFinalErrorAlert { completion?() }
        case .addressToEdit: return makeAddressToEditErrorAlert { completion?() }
        case .addNewAddress: return makeAddNewAddressErrorAlert { completion?() }
        }
    }
}

// MARK: - Methods
private extension DeliveryModuleFactory {
    func makeDeliveryModule() -> DeliveryViewController {
        let configurator = DeliveryConfigurator(storage: storage, storageService: storageService)
        return configurator.configure()
    }

    // Создаем экран с выбором адреса
    func makeChooseAddressModule() -> ChooseAddressViewController {
        let configurator = ChooseAddressConfigurator(storageService: storageService)
        return configurator.configure()
    }

//    func makeChooseAddressModule() -> ChooseAddressVC {
//        let viewModel = ChooseAddressVM(storage: storage, storageService: storageService)
//        let view = ChooseAddressVC(viewModel: viewModel)
//        return view
//    }

    func makeChoosePaymentMethodModule() -> ChoosePaymentMethodVC {
        let configurator = PaymentMethodConfigurator(storage: storage)
        return configurator.configure()
    }

    func makeEditAddressModule() -> EditAddressViewController {
        let configurator = EditAddressConfigurator(storage: addressStorage)
        return configurator.configure()
    }

    func makeAddNewAddressModule() -> AddNewAddressViewController {
        let configurator = AddNewAddressConfigurator(storage: addressStorage)
        return configurator.configure()
    }

    func makeFinalModule() -> FinalViewController {
        let configurator = FinalConfigurator(storageService: storageService)
        return configurator.configure()
    }
}

// MARK: - Errors
private extension DeliveryModuleFactory {
    func makeDeliveryErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.delivery) {
            completion?()
        }
    }

    // Алерт ошибка экрана выбрать адрес
    func makeChooseAddressErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.chooseAddress) {
            completion?()
        }
    }

    // Алерт ошибка экрана выбрать адрес
    func makePaymentMethodErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.paymentMethod) {
            completion?()
        }
    }

    // Алерт ошибка экрана выбрать адрес
    func makeFinalErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.final) {
            completion?()
        }
    }

    // Алерт ошибка экрана выбрать адрес
    func makeAddressToEditErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.addressToEdit) {
            completion?()
        }
    }

    // Алерт ошибка экрана добавить новый адрес
    func makeAddNewAddressErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.addNewAddress) {
            completion?()
        }
    }
}
