import Foundation
import UIKit

// Протокол фабрики, в котором метод создания всех экранов
protocol ProfileModuleFactory: AnyObject {
    func makeModule<T: UIViewController>(for profileScreen: ProfileModule, completion: (() -> Void)?) -> T
}

extension ProfileModuleFactory {
    // Метод создания экрана без комплишена (нужен в большинстве случаев)
    func makeModule<T: UIViewController>(for profileScreen: ProfileModule) -> T {
        return makeModule(for: profileScreen, completion: nil)
    }
}

// Enum который указывает список экранов
enum ProfileModule {
    case profile
    case personalData
    case delivery
    case chatAlert
    case promo
    case error
}

// Класс фабрика экранов отвечает за создание экранов
final class ProfileScreenFactory {
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
extension ProfileScreenFactory: ProfileModuleFactory {
    func makeModule<T: UIViewController>(for profileScreen: ProfileModule, completion: (() -> Void)? = nil) -> T {
        let vc: UIViewController =
            switch profileScreen {
            case .profile: makeProfileScreen()
            case .personalData: makePersonalDataScreen()
            case .delivery: makeAddressScreen()
            case .chatAlert: makeChatAlertScreen()
            case .promo: makePromoScreen()
            case .error: makeErrorAlertScreen(.profile) { completion?() }
            }

        guard let typedVC = vc as? T else { fatalError("Can't create screen") }

        return typedVC
    }
}

// MARK: - Supporting methods (Здесь создаем конкретные экраны)
private extension ProfileScreenFactory {
    // Создаем экран с персональными данными
    func makeProfileScreen() -> ProfileViewController {
        let profileConfigurator = ProfileConfigurator(moduleFactory: self, storage: storage)
        return profileConfigurator.configure()
    }

    // Создаем экран с персональными данными
    func makePersonalDataScreen() -> PersonalViewController {
        let viewModel = PersonalViewModel(storage: storage)
        let view = PersonalViewController(viewModel: viewModel)
        return view
    }

    // Создаем экран с выбором адреса
    func makeAddressScreen() -> ChooseAddressVC {
        let viewModel = ChooseAddressVM(storage: deliveryStorage, storageService: storageService)
        let view = ChooseAddressVC(viewModel: viewModel)
        return view
    }

    func makeChatAlertScreen() -> AppActionSheet {
        return AppActionSheet()
    }

    func makePromoScreen() -> PromoViewController {
        return PromoViewController(storage: storage)
    }

    func makeErrorAlertScreen(_ type: AlertType, completion: (() -> Void)? = nil) -> UIAlertController {
        return AppAlert.create(type) {
            completion?()
        }
    }
}
