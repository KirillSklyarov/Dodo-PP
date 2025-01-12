import Foundation

// Класс фабрика экранов отвечает за создание экранов
final class ScreenFactory {

    // MARK: - Properties
    private let storageService: DataManager
    private let featureToggleService: FeatureToggleService

    let mainScreenFactory: MainScreenFactoryProtocol
    let profileModuleFactory: ProfileModuleFactory
    let addressScreenFactory: AddressScreenFactoryProtocol
    let cartScreenFactory: any CartModuleFactoryProtocol
    let deliveryModuleFactory: any DeliveryModuleFactoryProtocol

    // MARK: - Init
    init(storageService: DataManager, featureToggleService: FeatureToggleService) {
        self.storageService = storageService
        self.featureToggleService = featureToggleService
        mainScreenFactory = MainScreenFactory(storage: storageService.mainStorage, featureToggleService: featureToggleService)
        profileModuleFactory = ProfileModuleFactory(storage: storageService.profileStorage, deliveryStorage: storageService.deliveryStorage, storageService: storageService.dataStorageService)
        addressScreenFactory = AddressScreenFactory(storage: storageService.addressStorage)
        cartScreenFactory = CartModuleFactory(dataManager: storageService)
        deliveryModuleFactory = DeliveryModuleFactory(storageService: storageService)
    }
}

// MARK: - Methods
extension ScreenFactory {
    func makeFeatureTogglesScreen() -> FeatureToggleVC {
        return FeatureToggleVC(storage: storageService.featureToggleStorage)
    }

    func makeAppStartScreen() -> AppStartViewController {
        return AppStartViewController()
    }
}
