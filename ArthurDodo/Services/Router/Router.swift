import UIKit

// Роутер отвечает за навигацию в приложении. Мы сразу в ините передаем его навигационный контроллер. C помощью замыканий (completion) мы отрабатываем обратные действия, которые вызываются уже на самом главном экране (это может быть MainVC или CartVC). Мы используем visibleViewController так как иногда встречаются вложенные модальные экраны и они без visibleViewController работать не будут.
final class Router {

    // MARK: - Properties
    weak var di: DependencyContainer!
    private let navigationController: UINavigationController

    var onAllScreenDismissed: (() -> Void)?

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Navigation methods
extension Router {
    func showMainScreen() {
        let vc = di.screenFactory.makeMainScreen()
        navigationController.pushViewController(vc, animated: true)
    }

    func showProfileScreen() {
        let vc = di.screenFactory.makeProfileScreen()
        navigationController.present(vc, animated: true)
    }

    func showProductDetailsScreen(completion: (() -> Void)?) {
        let vc = di.screenFactory.makeProductDetailsScreen()
        vc.onCartButtonTapped = completion

        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showStories(_ indexPath: IndexPath, completion: (() -> Void)?) {
        let vc = di.screenFactory.makeStoriesScreen(indexPath: indexPath)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
        vc.onStoriesVCDismissed = completion
    }

    func showAddress() {
        let vc = di.screenFactory.makeAddressScreen()
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }

    func showCart(completion: (() -> Void)?) {
        let cartVC = di.screenFactory.makeCartScreen()
        let vc = UINavigationController(rootViewController: cartVC)
        navigationController.present(vc, animated: true)

        cartVC.onCartVCDismissed = completion
    }

    func showChatAlert() {
        let vc = di.screenFactory.makeChatAlertScreen()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController.visibleViewController?.present(vc, animated: false)
    }

    func showPersonalData() {
        let vc = di.screenFactory.makePersonalDataScreen()
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showApplySpecialOffer(_ offer: Promo) {
        let vc = di.screenFactory.makeApplySpecialOfferScreen(offer)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showDelivery() {
        let vc = di.screenFactory.makeDeliveryScreen()
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showChooseAddress(completion: ((String) -> Void)?) {
        let vc = di.screenFactory.makeChooseAddressScreen()
        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: false)
        guard let chooseVC = vc.viewControllers.first as? ChooseAddressVC else { return }
        chooseVC.onAddressCellTapped = completion
    }

    func showChoosePaymentMethod(completion: ((PaymentMethod) -> Void)?) {
        let vc = di.screenFactory.makeChoosePaymentMethodScreen()
        navigationController.visibleViewController?.present(vc, animated: false)
        guard let paymentVC = vc.viewControllers.first as? ChoosePaymentMethodVC else { return }
        paymentVC.onPaymentMethodSelected = completion
    }

    func showFinalVC() {
        let vc = di.screenFactory.makeFinalVCScreen()
        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: false)
    }

    func dismissAllVC() {
        navigationController.dismiss(animated: true)
        onAllScreenDismissed?()
    }

    func showEditAddressVC(_ address: Address) {
        let vc = di.screenFactory.makeEditAddressScreen(address)
        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showAddNewAddressVC() {
        let vc = di.screenFactory.makeAddNewAddressScreen()
        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showPopUpView(_ popUpView: CpfcPopupView?) {
        guard let popUpView else { print("PopUpView is nil"); return }
        navigationController.visibleViewController?.present(popUpView, animated: true)
    }
}

