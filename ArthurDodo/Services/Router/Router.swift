import UIKit

//  Роутер отвечает за навигацию в приложении. Мы сразу в ините передаем его навигационный контроллер. C помощью замыканий (completion) мы отрабатываем обратные действия, которые вызываются уже на самом главном экране (это может быть MainVC или CartVC). Мы используем visibleViewController так как иногда встречаются вложенные модальные экраны и они без visibleViewController работать не будут.
final class Router {

    // MARK: - Properties
    private let navigationController: UINavigationController

    // MARK: - Init
    init() {
        self.navigationController = UINavigationController()
    }
}

// MARK: - Navigation methods - Version 2
extension Router {
    // Метод present навигации.
    // На вход приходят:
    //              vc - какой экран нужно показать,
    //              parentVC - с какого экрана идет показ (опционально, потому что может быть показ через навигационный контроллер)
    //              modalPresentation - показывать ли на весь экран
    //              animated - понятно, с анимацией или сразу показать
    func present(vc: UIViewController,
                 parentVC: UIViewController? = nil,
                 modalPresentation: UIModalPresentationStyle = .fullScreen,
                 animated: Bool = true) {
        vc.modalPresentationStyle = modalPresentation
        if let parentVC {
            present(parent: parentVC, vc: vc, animated: animated)
        } else {
            present(vc: vc, animated: animated)
        }
    }

    func dismissVC(vc: UIViewController) {
        vc.dismiss(animated: true)
    }

    func setRootNavigation() -> UINavigationController {
        navigationController
    }
}

private extension Router {
    // Метод present, когда у нам необходим родитель, от которого будет исходить показ нового экрана
    private func present(parent: UIViewController, vc: UIViewController, animated: Bool) {
        parent.present(vc, animated: animated)
    }

    // Метод present, когда сам навигационный контроллер показывает новый экран
    private func present(vc: UIViewController, animated: Bool) {
        navigationController.present(vc, animated: animated)
    }
}



// MARK: - Navigation methods
//extension Router {
//
//
//    func showMainScreen() {
//        let main = screenFactory.makeMainScreen()
//        let vc = UINavigationController(rootViewController: main)
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.present(vc, animated: false)
//    }
//
//    func showProfileScreen() {
//        let vc = screenFactory.makeProfileScreen()
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
//    func showChatAlert() {
//        let vc = screenFactory.makeChatAlertScreen()
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        navigationController.visibleViewController?.present(vc, animated: false)
//    }
//
//    func showProductDetailsScreen(completion: (() -> Void)?) {
//        let vc = screenFactory.makeProductDetailsScreen()
//        vc.onCartButtonTapped = completion
//
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
//    func showStories(_ indexPath: IndexPath, completion: (() -> Void)?) {
//        let vc = screenFactory.makeStoriesScreen(indexPath: indexPath)
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.present(vc, animated: true)
//        vc.onStoriesVCDismissed = completion
//    }
//
//    func showAddress() {
//        let vc = screenFactory.makeAddressScreen()
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
//    func showCart(completion: (() -> Void)?) {
//        let cartVC = screenFactory.makeCartScreen()
//        let vc = UINavigationController(rootViewController: cartVC)
//        navigationController.visibleViewController?.present(vc, animated: true)
//
////        cartVC.onCartVCDismissed = completion
//    }
//
//
//    func showPersonalData() {
//        let vc = screenFactory.makePersonalDataScreen()
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
//    func showApplySpecialOffer(_ offer: Promo) {
//        let vc = screenFactory.makeApplySpecialOfferScreen(offer)
//        guard let configureSheet = vc.sheetPresentationController else { return }
//        configureSheet.detents = [.medium()]
//        configureSheet.prefersGrabberVisible = true
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
//    func showDelivery() {
//        let vc = screenFactory.makeDeliveryScreen()
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
////    func showChooseAddress(completion: ((String) -> Void)?) {
////        let vc = screenFactory.makeChooseAddressScreen()
////        vc.modalPresentationStyle = .fullScreen
////        navigationController.visibleViewController?.present(vc, animated: false)
////        guard let chooseVC = vc.viewControllers.first as? ChooseAddressVC else { return }
////        chooseVC.onAddressCellTapped = completion
////    }
//
////    func showChoosePaymentMethod(completion: ((PaymentMethod) -> Void)?) {
////        let vc = screenFactory.makeChoosePaymentMethodScreen()
////        navigationController.visibleViewController?.present(vc, animated: false)
////        guard let paymentVC = vc.viewControllers.first as? ChoosePaymentMethodVC else { return }
////        paymentVC.onPaymentMethodSelected = completion
////    }
//
//    func showFinalVC() {
//        let vc = screenFactory.makeFinalVCScreen()
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: false)
//    }
//
//    func showEditAddressVC(_ address: Address) {
//        let vc = screenFactory.makeEditAddressScreen(address)
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
//    func showAddNewAddressVC() {
//        let vc = screenFactory.makeAddNewAddressScreen()
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }
//
//    func showPopUpView(_ popUpView: CpfcPopupView?) {
//        guard let popUpView else { print("PopUpView is nil"); return }
//        navigationController.visibleViewController?.present(popUpView, animated: true)
//    }
//
//    func showEditProductVC(completion: (() -> Void)?) {
//        let vc = screenFactory.makeEditProductScreen()
//        navigationController.visibleViewController?.present(vc, animated: true)
//        vc.onCartButtonTapped = completion
//    }
//
//    func dismissCurrentVC() {
//        navigationController.visibleViewController?.dismiss(animated: true)
//    }
//
//    func dismissAllVC() {
//        navigationController.dismiss(animated: true)
//        onAllScreenDismissed?()
//    }
//}
