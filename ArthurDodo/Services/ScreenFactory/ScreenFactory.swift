import UIKit

// Класс фабрика экранов отвечает за создание экранов
final class ScreenFactory {
    // MARK: - Properties
    private let storage: DataStorage
    let profileScreenFactory: ProfileScreenFactory
    let addressScreenFactory: AddressScreenFactory
    let cartScreenFactory: CartScreenFactory
    let deliveryScreenFactory: DeliveryScreenFactory

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
        profileScreenFactory = ProfileScreenFactory(storage: storage.profileStorage)
        addressScreenFactory = AddressScreenFactory(storage: storage.addressStorage)
        cartScreenFactory = CartScreenFactory(storage: storage.cartStorage, storageService: storage)
        deliveryScreenFactory = DeliveryScreenFactory(storage: storage.deliveryStorage, storageService: storage)
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

    func makeChooseAddressScreen() -> ChooseAddressVC {
        return ChooseAddressVC(storage: storage)
    }

    func makeChoosePaymentMethodScreen() -> ChoosePaymentMethodVC {
        return ChoosePaymentMethodVC(storage: storage.deliveryStorage)
    }

    func makeFinalVCScreen() -> FinalVC {
        return FinalVC(storage: storage)
    }

    func makeFeatureTogglesScreen() -> FeatureToggleVC {
        return FeatureToggleVC(storage: storage)
    }

    func makeAlertScreen(_ type: AlertType) -> UIAlertController {
        return AppAlert.create(type)
    }
}

// MARK: - Cart module
extension ScreenFactory {
    func makeCartScreen() -> CartViewController {
        return cartScreenFactory.makeCartScreen()
    }

    func makePromoScreen(_ offer: Promo) -> PromoViewController {
        return PromoViewController(with: offer)
    }

    //    func makeEditProductScreen() -> EditProductViewController {
    //        return EditProductViewController(storage: storage)
    //    }

}

// MARK: - Profile module
//extension ScreenFactory {
//    func makeProfileScreen() -> ProfileViewController {
//        return profileScreenFactory.makeProfileScreen()
//    }
//
//    func makePersonalDataScreen() -> PersonalViewController {
//        return profileScreenFactory.makePersonalDataScreen()
//    }
//
//    func makeChatAlertScreen() -> AppActionSheet {
//        return profileScreenFactory.makeChatAlertScreen()
//    }
//
//    func makeApplySpecialOfferScreen(_ offer: Promo) -> PromoViewController {
//        return PromoViewController(with: offer)
//    }
//}

// MARK: - Address module
//extension ScreenFactory {
//    func makeAddressScreen() -> AddressViewController {
//        return addressScreenFactory.makeAddressScreen()
//    }
//
//    func makeEditAddressScreen() -> EditAddressViewController {
//        return addressScreenFactory.makeEditAddressScreen()
//    }
//
//    func makeAddNewAddressScreen() -> AddNewAddressViewController {
//        return addressScreenFactory.makeAddNewAddressScreen()
//    }
//}
