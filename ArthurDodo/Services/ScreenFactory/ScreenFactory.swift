import UIKit

// Класс фабрика экранов отвечает за создание экранов
final class ScreenFactory {
    // MARK: - Properties
    private let storage: DataStorage

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
    }
}

// MARK: - Methods
extension ScreenFactory {
    func makeMainScreen() -> MainViewController {
        return MainViewController(storage: storage)
    }
    
    func makeProfileScreen() -> ProfileViewController {
        return ProfileViewController(storage: storage)
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
    
    func makeChatAlertScreen() -> CustomActionSheet {
        return CustomActionSheet()
    }
    
    func makePersonalDataScreen() -> PersonalViewController {
        return PersonalViewController()
    }
    
    func makeApplySpecialOfferScreen(_ offer: Promo) -> ApplyOfferViewController {
        return ApplyOfferViewController(with: offer)
    }

    func makeDeliveryScreen() -> DeliveryVC {
        return  DeliveryVC(storage: storage)
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
        return AddNewAddressViewController()
    }

    func makeEditProductScreen() -> EditProductViewController {
        return EditProductViewController(storage: storage)
    }
}
