import UIKit

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    var storage: DataStorage
    var navigationController: UINavigationController
    var callback: ((UIViewController) -> Void)?
    var parentCoordinator: MainCoordinator?
    var deliveryVC: DeliveryVC?

    // MARK: - Init
    init(storage: DataStorage, navigationController: UINavigationController) {
        self.storage = storage
        self.navigationController = navigationController
    }
}

// MARK: - Public methods
extension CartCoordinator {
    func start() {
//        let cartVC = CartViewController(storage: storage)
//        cartVC.coordinator = self
//        let vc = UINavigationController(rootViewController: cartVC)
//        navigationController.present(vc, animated: true)
//
//        cartVC.onCartVCDismissed = { [weak self] in
//            guard let self else { print("CartCoordinator is deallocated"); return }
//            let mainVC = parentCoordinator?.viewController
//            mainVC?.updateCart()
//        }
    }

    func showDelivery() {
//        let deliveryVC = DeliveryVC(storage: storage)
//        deliveryVC.coordinator = self
//        let vc = UINavigationController(rootViewController: deliveryVC)
//        navigationController.visibleViewController?.present(vc, animated: true)
//        self.deliveryVC = deliveryVC
    }

    func showChoosePaymentMethodVC() {
//        let paymentVC = ChoosePaymentMethodVC()
//        let vc = UINavigationController(rootViewController: paymentVC)
//        navigationController.visibleViewController?.present(vc, animated: false)
//
//        paymentVC.onPaymentMethodSelected = { [weak self] paymentMethod in
//            guard let self else { print("CartCoordinator is deallocated"); return }
//            deliveryVC?.updateUI(paymentMethod)
//        }
    }

    func showChooseAddress() {
//        let chooseVC = ChooseAddressVC(storage: storage)
//        chooseVC.coordinator = self
//        let vc = UINavigationController(rootViewController: chooseVC)
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: false)
//
//        chooseVC.onAddressCellTapped = { [weak self] addressName in
//            self?.deliveryVC?.updateAddress(addressName)
//        }
    }

    func showFinalVC() {
//        let finalVC = FinalVC(storage: storage)
//        finalVC.coordinator = self
//        let vc = UINavigationController(rootViewController: finalVC)
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: false)
    }

    // Закрываем все окна до Main
    func dismissAllVC() {
//        navigationController.dismiss(animated: true)
    }

    func showEditAddressVC(_ address: Address) {
//        let vc = EditAddressViewController()
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//        vc.getAddressToEdit(address)
    }

//    func showAddNewAddressVC() {
//        let vc = AddNewAddressViewController()
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//    }

    func showProductDetails() {
        parentCoordinator?.showProductDetails()
    }

    func showApplySpecialOffer(_ offer: Promo) {
//        let vc = ApplyOfferViewController()
//        guard let configureSheet = vc.sheetPresentationController else { return }
//        configureSheet.detents = [.medium()]
//        configureSheet.prefersGrabberVisible = true
//        navigationController.visibleViewController?.present(vc, animated: true)
//        vc.configureViewController(offer)
    }
}
