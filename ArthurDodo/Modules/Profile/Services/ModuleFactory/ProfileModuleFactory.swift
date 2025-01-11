import UIKit

// Протокол фабрики, в котором метод создания всех экранов
protocol ProfileModuleFactoryProtocol: AnyObject {
    func makeModule(for profileScreen: ProfileModule) -> UIViewController
    func makeErrorAlert(for errorAlert: AlertType, completion: (() -> Void)?) -> UIAlertController
}

// Enum который указывает список экранов
enum ProfileModule {
    case profile
    case personalData
    case chooseAddress
    case chatAlert
    case promo
}

// Класс фабрика экранов отвечает за создание экранов
final class ProfileModuleFactory {
    // MARK: - Properties
    private let storage: ProfileStorage
    private let deliveryStorage: DeliveryStorage
    private let storageService: DataStorageService

    // MARK: - Init
    init(storage: ProfileStorage, deliveryStorage: DeliveryStorage, storageService: DataStorageService) {
        self.storage = storage
        self.deliveryStorage = deliveryStorage
        self.storageService = storageService
    }
}

// MARK: - ProfileScreenFactoryProtocol
extension ProfileModuleFactory: ProfileModuleFactoryProtocol {
    func makeModule(for profileScreen: ProfileModule) -> UIViewController {
        switch profileScreen {
        case .profile: makeProfileModule()
        case .personalData: makePersonalDataModule()
        case .chooseAddress: makeAddressModule()
        case .chatAlert: makeSupportModule()
        case .promo: makePromoModule()
        }
    }

    func makeErrorAlert(for errorAlert: AlertType, completion: (() -> Void)?) -> UIAlertController {
        switch errorAlert {
        case .profile: makeErrorAlertScreen(.profile) { completion?() }
        case .cart: makeErrorAlertScreen(.cart) { completion?() }
        case .productDetails: makeErrorAlertScreen(.productDetails) { completion?() }
        case .chooseAddress: makeErrorAlertScreen(.chooseAddress) { completion?() }
        case .personalData: makeErrorAlertScreen(.personalData) { completion?() }
        case .editItem: makeErrorAlertScreen(.editItem) { completion?() }
        }
    }
}

// MARK: - Supporting methods (Здесь создаем конкретные экраны)
private extension ProfileModuleFactory {
    // Создаем экран с персональными данными
    func makeProfileModule() -> ProfileViewController {
        let profileConfigurator = ProfileConfigurator(moduleFactory: self, storage: storage)
        return profileConfigurator.configure()
    }

    // Создаем экран с персональными данными
    func makePersonalDataModule() -> PersonalViewController {
        let personalConfigurator = PersonalConfigurator(moduleFactory: self, storage: storage)
        return personalConfigurator.configure()
    }

    // Создаем модуль с контактами поддержки (написать, позвонить)
    func makeSupportModule() -> SupportViewController {
        let configurator = SupportConfigurator()
        return configurator.configure()
    }

    // Создаем модуль с акциями
    func makePromoModule() -> PromoViewController {
        let configurator = PromoConfigurator(storage: storage)
        return configurator.configure()
    }

    // Создаем экран с выбором адреса
    func makeAddressModule() -> ChooseAddressViewController {
        let configurator = ChooseAddressConfigurator(moduleFactory: self, storageService: storageService)
        return configurator.configure()
    }

    func makeErrorAlertScreen(_ type: AlertType, completion: (() -> Void)? = nil) -> UIAlertController {
        return AppAlert.create(type) {
            completion?()
        }
    }
}
