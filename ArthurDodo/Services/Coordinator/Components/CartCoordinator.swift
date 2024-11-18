import UIKit

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    private let storage: DataStorage
    private let router: Router
    private let screenFactory: ScreenFactory
    private var cartVC: CartViewController?
    private var mainVC: MainViewController

    // MARK: - Init
    init(storage: DataStorage, router: Router, screenFactory: ScreenFactory, mainVC: MainViewController) {
        self.storage = storage
        self.router = router
        self.screenFactory = screenFactory
        self.mainVC = mainVC
    }

    deinit {
        print("CartCoordinator deinit")
    }

    func start(_ parentVC: UIViewController) {
        let cartVC = screenFactory.makeCartScreen()
        self.cartVC = cartVC
        router.present(vc: cartVC, parentVC: parentVC, modalPresentation: .automatic)

        cartVC.onCartVCDismissed = { [weak self] in
            guard let self else { print(#function); return }
            router.dismissVC(vc: cartVC)
            mainVC.updateCart()
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

    private func showApplySpecialOffer(_ offer: Promo) {
        let vc = screenFactory.makeApplySpecialOfferScreen(offer)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        router.present(vc: vc, parentVC: cartVC, modalPresentation: .automatic)
    }

    private func showEditProduct() {
        let vc = screenFactory.makeEditProductScreen()
        router.present(vc: vc, parentVC: cartVC, modalPresentation: .automatic)

        vc.onCartButtonTapped = { [weak self] in
            guard let self else { print(#function); return }
            cartVC?.updateCart() // Говорим главному экрану обновить корзину
            router.dismissVC(vc: vc) // Закрываем текущий экран
        }

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc) // Закрываем текущий экран
        }

        vc.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(vc: popUpView, parentVC: vc, modalPresentation: .popover, animated: true)
        }
    }

    func showDelivery() {
        let vc = screenFactory.makeDeliveryScreen()
        router.present(vc: vc, parentVC: cartVC, modalPresentation: .automatic)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }

        vc.onShowChooseAddress = { [weak self] in
            self?.showChooseAddress(parentVC: vc)
        }

        vc.onShowChoosePaymentMethod = { [weak self] in
            self?.showChoosePaymentMethod(parentVC: vc)
        }

        vc.onShowFinalVC = { [weak self] in
            self?.showFinalVC(parentVC: vc)
        }
    }

    private func showFinalVC(parentVC: DeliveryVC) {
        let vc = screenFactory.makeFinalVCScreen()
        router.present(vc: vc, parentVC: parentVC)

        vc.onFinalVCDismissed = { [weak self] in
            guard let self else { print(#function); return }
            print("mainVC \(mainVC)")
            router.dismissVC(vc: self.mainVC)
            mainVC.isNeedToShowOrderView()
        }
    }

    private func showChoosePaymentMethod(parentVC: DeliveryVC) {
        let vc = screenFactory.makeChoosePaymentMethodScreen()
        router.present(vc: vc, parentVC: parentVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }

        vc.onPaymentMethodSelected = { [weak self] paymentMethod in
            parentVC.updateUI(paymentMethod)
            self?.router.dismissVC(vc: vc)
        }
    }

    func showChooseAddress(parentVC: DeliveryVC) {
        let vc = screenFactory.makeChooseAddressScreen()
        router.present(vc: vc, parentVC: parentVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
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

    private func showEditAddressVC(_ address: Address, parentVC: ChooseAddressVC) {
        let vc = screenFactory.makeEditAddressScreen(address)
        router.present(vc: vc, parentVC: parentVC)
    }

    private func showAddNewAddressVC(parentVC: ChooseAddressVC) {
        let vc = screenFactory.makeAddNewAddressScreen()
        router.present(vc: vc, parentVC: parentVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }
    }
}
