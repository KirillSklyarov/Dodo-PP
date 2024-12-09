import UIKit

final class DeliveryCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory
    private var deliveryVC: DeliveryVC?

    var onFinishFlow: (() -> Void)?
    var onDismissed: (() -> Void)?

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
        self.deliveryVC = vc

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
            self?.onDismissed?()
        }

        vc.onShowChooseAddress = { [weak self] in
            self?.showChooseAddress(vc)
        }

        vc.onShowChoosePaymentMethod = { [weak self] in
            self?.showChoosePaymentMethod(vc)
        }

        vc.onShowFinalVC = { [weak self] in
            self?.showFinalVC(parentVC: vc)
        }

        router.present(vc, isParent: true)
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    func showChooseAddress(_ parentVC: UIViewController) {
        let vc = screenFactory.makeChooseAddressScreen()
        router.present(parentVC, vcToShow: vc)

        // Нажали на закрыть окно
        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        // Выбрали ячейку
        vc.onAddressCellTapped = { [weak self] addressName in
            self?.updateUI(addressName: addressName)
        }

        // Нажали на редактирование адреса
        vc.onEditAddressCellTapped = { [weak self] address in
            self?.showEditAddressVC(vc)
        }

        // Нажали на добавить новый адрес
        vc.onShowAddNewAddress = { [weak self] in
            self?.showAddNewAddressVC(vc)
        }
    }

    func showEditAddressVC(_ parentVC: UIViewController) {
        let vc = screenFactory.addressScreenFactory.makeEditAddressScreen()
        let presenter = vc.presenter

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        presenter.onSaveButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        router.present(parentVC, vcToShow: vc, modalPresentation: .fullScreen)
    }

    func showAddNewAddressVC(_ parentVC: UIViewController) {
        let vc = screenFactory.addressScreenFactory.makeAddNewAddressScreen()
        let presenter = vc.presenter

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        presenter.onSaveNewAddressButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        router.present(parentVC, vcToShow: vc, modalPresentation: .fullScreen)
    }

    func showChoosePaymentMethod(_ parentVC: UIViewController) {
        let vc = screenFactory.makeChoosePaymentMethodScreen()
        router.present(parentVC, vcToShow: vc)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        vc.onPaymentMethodSelected = { [weak self] paymentMethod in
            self?.updateUI(paymentMethod: paymentMethod)
            self?.router.dismiss(from: parentVC)
        }
    }

    func showFinalVC(parentVC: UIViewController) {
        let vc = screenFactory.makeFinalVCScreen()
        router.present(parentVC, vcToShow: vc)

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
        guard let deliveryVC else { print("Error: Top view controller is not DeliveryVC"); return }
        if let addressName { deliveryVC.updateAddress(addressName) }
        if let paymentMethod { deliveryVC.updateUI(paymentMethod) }
    }
}
