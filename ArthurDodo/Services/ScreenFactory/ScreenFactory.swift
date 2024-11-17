import UIKit

// Класс фабрика экранов отвечает за создание экранов
final class ScreenFactory {
    // MARK: - Properties
    private let storage: DataStorage
    weak var router: Router!

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
    }
}

// MARK: - Methods
extension ScreenFactory {
    func makeMainScreen() -> MainViewController {
        return MainViewController(storage: storage, router: router)
    }
    
    func makeProfileScreen() -> ProfileViewController {
        return ProfileViewController(storage: storage, router: router)
    }
    
    func makeProductDetailsScreen() -> ProductDetailsViewController {
        return ProductDetailsViewController(storage: storage)
    }
    
    func makeStoriesScreen(indexPath: IndexPath) -> StoriesVC {
        let story = storage.getFetchedStories()
        return StoriesVC(indexPath: indexPath, story: story)
    }
    
    func makeAddressScreen() -> AddressViewController {
        return AddressViewController(storage: storage, router: router)
    }
    
    func makeCartScreen() -> CartViewController {
        return CartViewController(storage: storage, router: router)
    }
    
    func makeChatAlertScreen() -> CustomActionSheet {
        return CustomActionSheet(router: router)
    }
    
    func makePersonalDataScreen() -> UINavigationController {
        let personalDataVC = PersonalViewController(router: router)
        let vc = UINavigationController(rootViewController: personalDataVC)
        return vc
    }
    
    func makeApplySpecialOfferScreen(_ offer: Promo) -> ApplyOfferViewController {
        return ApplyOfferViewController(with: offer)
    }

    func makeDeliveryScreen() -> UINavigationController {
        let deliveryVC = DeliveryVC(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: deliveryVC)
        return vc
    }

    func makeChooseAddressScreen() -> UINavigationController {
        let chooseVC = ChooseAddressVC(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: chooseVC)
        return vc
    }

    func makeChoosePaymentMethodScreen() -> UINavigationController {
        let paymentVC = ChoosePaymentMethodVC(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: paymentVC)
        return vc
    }

    func makeFinalVCScreen() -> UINavigationController {
        let finalVC = FinalVC(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: finalVC)
        return vc
    }

    func makeEditAddressScreen(_ address: Address) -> EditAddressViewController {
        return EditAddressViewController(address, storage: storage, router: router)
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        return AddNewAddressViewController(router: router)
    }

    func makeEditProductScreen() -> EditProductViewController {
        return EditProductViewController(storage: storage, router: router)
    }
}
