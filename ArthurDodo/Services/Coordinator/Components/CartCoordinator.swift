import UIKit

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory
    private var cartVC: CartViewController?

    var onFinishFlow: (() -> Void)?
    var onCartDismissed: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("CartCoordinator deinit")
    }

    func start() {
        let cartVC = screenFactory.makeCartScreen()
        self.cartVC = cartVC
        router.setRootModule(cartVC, animation: false)

        cartVC.onCartVCDismissed = { [weak self] in
            guard let self else { print(#function); return }
            router.dismiss()
            onCartDismissed?()
        }

        cartVC.onShowEditProductVC = { [weak self] in
            self?.showEditProduct()
        }

        cartVC.onShowPromoVC = { [weak self] promo in
            self?.showApplySpecialOffer(promo)
        }

        cartVC.onShowDeliveryVC = { [weak self] in
            self?.showDelivery()
        }
    }
}

// MARK: - Supporting methods
private extension CartCoordinator {
    func showApplySpecialOffer(_ offer: Promo) {
        let vc = screenFactory.makeApplySpecialOfferScreen(offer)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        router.present(vc, modalPresentation: .automatic)
    }

    func showEditProduct() {
        let vc = screenFactory.makeEditProductScreen()
        router.present(vc, modalPresentation: .automatic)

        vc.onCartButtonTapped = { [weak self] in
            guard let self else { print(#function); return }
            cartVC?.updateCart() // Говорим главному экрану обновить корзину
            router.dismiss() // Закрываем текущий экран
        }

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss() // Закрываем текущий экран
        }

        vc.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, parentVC: vc, modalPresentation: .popover, animated: true)
        }
    }

    func showDelivery() {
        let vc = screenFactory.makeDeliveryScreen()
        router.present(vc, modalPresentation: .automatic)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        vc.onShowChooseAddress = { [weak self] in
            self?.showChooseAddress(parentVC: vc)
        }

        vc.onShowChoosePaymentMethod = { [weak self] in
            self?.showChoosePaymentMethod(parentVC: vc)
        }

        vc.onShowFinalVC = { [weak self] in
            self?.showFinalVC()
        }
    }

    func showFinalVC() {
        print(#function)
        let vc = screenFactory.makeFinalVCScreen()
        router.present(vc)

        vc.onFinalVCDismissed = { [weak self] in
            self?.onFinishFlow?()
        }
    }

    func showChoosePaymentMethod(parentVC: DeliveryVC) {
        let vc = screenFactory.makeChoosePaymentMethodScreen()
        router.present(vc, parentVC: parentVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        vc.onPaymentMethodSelected = { [weak self] paymentMethod in
            parentVC.updateUI(paymentMethod)
            self?.router.dismiss()
        }
    }

    func showChooseAddress(parentVC: DeliveryVC) {
        let vc = screenFactory.makeChooseAddressScreen()
        router.present(vc, parentVC: parentVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        vc.onAddressCellTapped = { addressName in
            parentVC.updateAddress(addressName)
        }

        vc.onEditAddressCellTapped = { [weak self] address in
            self?.showEditAddressVC(address, parentVC: vc)
        }

        vc.onShowAddNewAddress = { [weak self] in
            self?.showAddNewAddressVC(parentVC: vc)
        }
    }

    func showEditAddressVC(_ address: Address, parentVC: ChooseAddressVC) {
        let vc = screenFactory.makeEditAddressScreen(address)
        router.present(vc, parentVC: parentVC)
    }

    func showAddNewAddressVC(parentVC: ChooseAddressVC) {
        let vc = screenFactory.makeAddNewAddressScreen()
        router.present(vc, parentVC: parentVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }
    }
}
