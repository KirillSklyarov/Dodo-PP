import UIKit

// Протокол фабрики, в котором метод создания всех экранов
protocol ProfileModuleFactoryProtocol: BaseModuleFactory where Module == ProfileModule, ErrorType == ProfileError {

}

// Enum который указывает список экранов
enum ProfileModule {
    case profile
    case personalData
    case chooseAddress
    case chatAlert
    case promo
}

enum ProfileError {
    case profileError
    case chooseAddressError
    case personalDataError
    case promoError
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

    func makeErrorAlert(for errorAlert: ProfileError, completion: (() -> Void)?) -> UIAlertController {
        switch errorAlert {
        case .profileError: makeErrorAlertScreen(.profile) { completion?() }
        case .chooseAddressError: makeErrorAlertScreen(.chooseAddress) { completion?() }
        case .personalDataError: makeErrorAlertScreen(.personalData) { completion?() }
        case .promoError: makeErrorAlertScreen(.promo) { completion?() }
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
        let configurator = ChooseAddressConfigurator(storageService: storageService)
        return configurator.configure()
    }

    func makeErrorAlertScreen(_ type: AlertType, completion: (() -> Void)? = nil) -> UIAlertController {
        return AppAlert.create(type) {
            completion?()
        }
    }
}
