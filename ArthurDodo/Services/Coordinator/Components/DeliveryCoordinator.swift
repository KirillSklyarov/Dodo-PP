import UIKit

final class DeliveryCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory

    var onFinishFlow: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("DeliveryCoordinator deinit")
    }
}

// MARK: - Start
extension DeliveryCoordinator {
    func start() {
        let vc = screenFactory.makeDeliveryScreen()
        router.present(vc, modalPresentation: .automatic)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        vc.onShowChooseAddress = { [weak self] in
            self?.showChooseAddress()
        }

        vc.onShowChoosePaymentMethod = { [weak self] in
            self?.showChoosePaymentMethod()
        }

        vc.onShowFinalVC = { [weak self] in
            self?.showFinalVC()
        }
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    func showChooseAddress() {
        let vc = screenFactory.makeChooseAddressScreen()
        router.presentWithParent(vc)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        vc.onAddressCellTapped = { [weak self] addressName in
            self?.updateUI(addressName: addressName)
        }

        vc.onEditAddressCellTapped = { [weak self] address in
            self?.showEditAddressVC(address)
        }

        vc.onShowAddNewAddress = { [weak self] in
            self?.showAddNewAddressVC()
        }
    }

    func showEditAddressVC(_ address: Address) {
        let vc = screenFactory.makeEditAddressScreen(address)
        router.present(vc)
    }

    func showAddNewAddressVC() {
        let vc = screenFactory.makeAddNewAddressScreen()
        router.presentWithParent(vc)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }
    }

    func showChoosePaymentMethod() {
        let vc = screenFactory.makeChoosePaymentMethodScreen()
        router.present(vc, parentVC: true)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        vc.onPaymentMethodSelected = { [weak self] paymentMethod in
            self?.updateUI(paymentMethod: paymentMethod)
            self?.router.dismiss(isParent: true)
        }
    }

    func showFinalVC() {
        let vc = screenFactory.makeFinalVCScreen()
        router.present(vc, parentVC: true)

        vc.onFinalVCDismissed = { [weak self] in
            self?.router.dismiss()
            self?.onFinishFlow?()
        }
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    // Обновляет данные на главном экране этого потока (в данном случае экрана "Доставка"). Сначала находим верхний экран, потом обновляем те данные, которые не nil.
    func updateUI(addressName: String? = nil, paymentMethod: PaymentMethod? = nil) {
        guard let deliveryVC = router.getTopViewController() as? DeliveryVC else { print("Error: Top view controller is not DeliveryVC"); return }

        if let addressName {
            deliveryVC.updateAddress(addressName)
        }
        if let paymentMethod {
            deliveryVC.updateUI(paymentMethod)
        }
    }
}
