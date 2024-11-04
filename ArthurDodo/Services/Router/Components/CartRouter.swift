import UIKit

final class CartRouter {

    // MARK: - Properties
    var storage: DataStorage
    var navigationController: UINavigationController
    var callback: ((UIViewController) -> Void)?

    // MARK: - Init
    init(storage: DataStorage, navigationController: UINavigationController) {
        self.storage = storage
        self.navigationController = navigationController
    }
}

// MARK: - Public methods
extension CartRouter {
    func goToCart(router: AppRouter, callback: ((UIViewController) -> Void)?) {
        let cartVC = CartViewController(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: cartVC)
        navigationController.present(vc, animated: true) {
            callback?(cartVC)
        }
    }

    func goToDelivery(router: AppRouter) {
        let deliveryVC = DeliveryVC(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: deliveryVC)
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func goToChoosePaymentMethodVC(callback: ((UIViewController) -> Void)?) {
        let paymentVC = ChoosePaymentMethodVC()
        let vc = UINavigationController(rootViewController: paymentVC)
        navigationController.visibleViewController?.present(vc, animated: false) {
            callback?(paymentVC)
        }
    }

    func goToChooseAddress(router: AppRouter, callback: ((UIViewController) -> Void)?) {
        let chooseVC = ChooseAddressVC(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: chooseVC)
        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: false) {
            callback?(chooseVC)
        }
    }

    func goToFinalVC(router: AppRouter) {
        let finalVC = FinalVC(storage: storage, router: router)
        let vc = UINavigationController(rootViewController: finalVC)
        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: false)
    }

    func goToApplySpecialOffer(callback: ((UIViewController) -> Void)?) {
        let vc = ApplyOfferViewController()
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        navigationController.visibleViewController?.present(vc, animated: true) {
            callback?(vc)
        }
    }
}
