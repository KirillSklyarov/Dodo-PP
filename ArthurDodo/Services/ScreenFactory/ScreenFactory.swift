import Foundation

// Класс фабрика экранов отвечает за создание экранов
final class ScreenFactory {

    // MARK: - Properties
    private let storageService: DataManager

    let mainScreenFactory: MainScreenFactoryProtocol
    let profileScreenFactory: ProfileScreenFactoryProtocol
    let addressScreenFactory: AddressScreenFactoryProtocol
    let cartScreenFactory: CartScreenFactoryProtocol
    let deliveryScreenFactory: DeliveryScreenFactoryProtocol

    // MARK: - Init
    init(storageService: DataManager) {
        self.storageService = storageService
        mainScreenFactory = MainScreenFactory(storage: storageService.mainStorage)
        profileScreenFactory = ProfileScreenFactory(storage: storageService.profileStorage)
        addressScreenFactory = AddressScreenFactory(storage: storageService.addressStorage)
        cartScreenFactory = CartScreenFactory(dataManager: storageService)
        deliveryScreenFactory = DeliveryScreenFactory(storageService: storageService)
    }
}

// MARK: - Methods
extension ScreenFactory {
    func makeFeatureTogglesScreen() -> FeatureToggleVC {
        return FeatureToggleVC(storage: storageService.featureToggleStorage)
    }
}
