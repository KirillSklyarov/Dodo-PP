import UIKit

final class ScreenFactory {
    weak var di: DependencyContainer!
    
    func makeMainScreen() -> MainViewController {
        return MainViewController(storage: di.storage, router: di.router)
    }
    
    func makeProfileScreen() -> ProfileViewController {
        return ProfileViewController(storage: di.storage, router: di.router)
    }
    
    func makeProductDetailsScreen() -> ProductDetailsViewController {
        return ProductDetailsViewController(storage: di.storage, router: di.router)
    }
    
    func makeStoriesScreen(indexPath: IndexPath) -> StoriesVC {
        let story = di.storage.getFetchedStories()
        return StoriesVC(indexPath: indexPath, story: story)
    }
    
    func makeAddressScreen() -> AddressViewController {
        return AddressViewController(storage: di.storage, router: di.router)
    }
    
    func makeCartScreen() -> CartViewController {
        return CartViewController(storage: di.storage, router: di.router)
    }
    
    func makeChatAlertScreen() -> CustomActionSheet {
        return CustomActionSheet()
    }
    
    func makePersonalDataScreen() -> UINavigationController {
        let personalDataVC = PersonalViewController()
        let vc = UINavigationController(rootViewController: personalDataVC)
        return vc
    }
    
    func makeApplySpecialOfferScreen(_ offer: Promo) -> ApplyOfferViewController {
        return ApplyOfferViewController(with: offer)
    }

    func makeDeliveryScreen() -> UINavigationController {
        let deliveryVC = DeliveryVC(storage: di.storage, router: di.router)
        let vc = UINavigationController(rootViewController: deliveryVC)
        return vc
    }

    func makeChooseAddressScreen() -> UINavigationController {
        let chooseVC = ChooseAddressVC(storage: di.storage, router: di.router)
        let vc = UINavigationController(rootViewController: chooseVC)
        return vc
    }

    func makeChoosePaymentMethodScreen() -> UINavigationController {
        let paymentVC = ChoosePaymentMethodVC(storage: di.storage)
        let vc = UINavigationController(rootViewController: paymentVC)
        return vc
    }

    func makeFinalVCScreen() -> UINavigationController {
        let finalVC = FinalVC(storage: di.storage, router: di.router)
        let vc = UINavigationController(rootViewController: finalVC)
        return vc
    }

    func makeEditAddressScreen(_ address: Address) -> EditAddressViewController {
        return EditAddressViewController(address, storage: di.storage)
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        return AddNewAddressViewController()
    }

}
