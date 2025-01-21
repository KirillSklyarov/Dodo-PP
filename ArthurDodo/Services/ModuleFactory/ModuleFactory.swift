import Foundation

// Класс фабрика экранов отвечает за создание экранов
final class ModuleFactory {

    // MARK: - Properties
    private let storageService: DataManager
    private let featureToggleService: FeatureToggleService

    var mainModuleFactory: any MainModuleFactoryProtocol
    var profileModuleFactory: ProfileModuleFactory
    var addressModuleFactory: any AddressModuleFactoryProtocol
    var cartModuleFactory: any CartModuleFactoryProtocol
    var deliveryModuleFactory: any DeliveryModuleFactoryProtocol

    // MARK: - Init
    init(storageService: DataManager, featureToggleService: FeatureToggleService) {
        self.storageService = storageService
        self.featureToggleService = featureToggleService

        mainModuleFactory = MainModuleFactory(storage: storageService.mainStorage, featureToggleService: featureToggleService)

        profileModuleFactory = ProfileModuleFactory(storage: storageService.profileStorage, deliveryStorage: storageService.deliveryStorage, storageService: storageService.dataStorageService)

        addressModuleFactory = AddressModuleFactory(storage: storageService.addressStorage)

        cartModuleFactory = CartModuleFactory(dataManager: storageService)

        deliveryModuleFactory = DeliveryModuleFactory(storageService: storageService)
    }
}

// MARK: - Methods
extension ModuleFactory {
    func makeFeatureTogglesScreen() -> FeatureToggleVC {
        return FeatureToggleVC(storage: storageService.featureToggleStorage)
    }

    func makeAppStartScreen() -> AppStartViewController {
        return AppStartViewController()
    }
}
