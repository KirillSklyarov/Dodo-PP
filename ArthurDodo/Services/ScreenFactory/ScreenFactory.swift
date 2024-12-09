import UIKit

// Класс фабрика экранов отвечает за создание экранов
final class ScreenFactory {
    // MARK: - Properties
    private let storage: DataStorage
    let profileScreenFactory: ProfileScreenFactory

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
        profileScreenFactory = ProfileScreenFactory(storage: storage.profileStorage)
    }
}

// MARK: - Methods
extension ScreenFactory {
    func makeMainScreen() -> MainViewController {
        return MainViewController(storage: storage)
    }
    
    func makeProductDetailsScreen() -> ProductDetailsViewController {
        return ProductDetailsViewController(storage: storage)
    }
    
    func makeStoriesScreen(indexPath: IndexPath) -> StoriesVC {
        let story = storage.getFetchedStories()
        return StoriesVC(indexPath: indexPath, story: story)
    }
    
    func makeAddressScreen() -> AddressViewController {
        return AddressViewController(storage: storage)
    }
    
    func makeCartScreen() -> CartViewController {
        return CartViewController(storage: storage)
    }

    func makeDeliveryScreen() -> DeliveryVC {
        return DeliveryVC(storage: storage)
    }

    func makeChooseAddressScreen() -> ChooseAddressVC {
        return ChooseAddressVC(storage: storage)
    }

    func makeChoosePaymentMethodScreen() -> ChoosePaymentMethodVC {
        return ChoosePaymentMethodVC(storage: storage)
    }

    func makeFinalVCScreen() -> FinalVC {
        return FinalVC(storage: storage)
    }

    func makeEditAddressScreen(_ address: Address) -> EditAddressViewController {
        return EditAddressViewController(address, storage: storage)
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        return AddNewAddressViewController(storage: storage)
    }

    func makeEditProductScreen() -> EditProductViewController {
        return EditProductViewController(storage: storage)
    }

    func makeFeatureTogglesScreen() -> FeatureToggleVC {
        return FeatureToggleVC(storage: storage)
    }

    func makeAlertScreen(_ type: AlertType) -> UIAlertController {
        return AppAlert.create(type)
    }
}

// MARK: - Profile module
extension ScreenFactory {
    func makeProfileScreen() -> ProfileViewController {
        return profileScreenFactory.makeProfileScreen()
    }

    func makePersonalDataScreen() -> PersonalViewController {
        return profileScreenFactory.makePersonalDataScreen()
    }

    func makeChatAlertScreen() -> AppActionSheet {
        return profileScreenFactory.makeChatAlertScreen()
    }

    func makeApplySpecialOfferScreen(_ offer: Promo) -> PromoViewController {
        return PromoViewController(with: offer)
    }
}
