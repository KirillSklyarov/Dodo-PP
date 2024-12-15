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
        let vc = screenFactory.deliveryScreenFactory.makeDeliveryScreen()
        let presenter = vc.presenter
        self.deliveryVC = vc

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
            self?.onDismissed?()
        }

        presenter.onShowChooseAddress = { [weak self] in
            self?.showChooseAddress(vc)
        }

        presenter.onShowChoosePaymentMethod = { [weak self] in
            self?.showChoosePaymentMethod(vc)
        }

        presenter.onShowFinalVC = { [weak self] in
            self?.showFinalVC(parentVC: vc)
        }

        router.present(vc, isParent: true)
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    func showChooseAddress(_ parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeChooseAddressScreen()
        let presenter = vc.presenter
        router.present(parentVC, vcToShow: vc)

        // Нажали на закрыть окно
        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        // Выбрали ячейку
        presenter.onAddressCellTapped = { [weak self] addressName in
            self?.updateUI(addressName: addressName)
        }

        // Нажали на редактирование адреса
        presenter.onEditAddressCellTapped = { [weak self] address in
            self?.showEditAddressVC(vc)
        }

        // Нажали на добавить новый адрес
        presenter.onShowAddNewAddress = { [weak self] in
            self?.showAddNewAddressVC(vc)
        }
    }

    func showEditAddressVC(_ parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeEditAddressScreen()
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
        let vc = screenFactory.deliveryScreenFactory.makeAddNewAddressScreen()
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
        let vc = screenFactory.deliveryScreenFactory.makeChoosePaymentMethodScreen()
        let presenter = vc.presenter
        router.present(parentVC, vcToShow: vc)

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(from: parentVC)
        }

        presenter.onPaymentMethodSelected = { [weak self] paymentMethod in
            self?.updateUI(paymentMethod: paymentMethod)
            self?.router.dismiss(from: parentVC)
        }
    }

    // Показываем финальный экран
    func showFinalVC(parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeFinalVCScreen()
        let presenter = vc.presenter

        presenter.onFinalVCDismissed = { [weak self] in
            self?.router.dismiss()
            self?.onFinishFlow?()
        }

        router.present(parentVC, vcToShow: vc)
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    // Обновляет данные на главном экране этого потока (в данном случае экрана "Доставка"). Сначала находим верхний экран, потом обновляем те данные, которые не nil.
    func updateUI(addressName: String? = nil, paymentMethod: PaymentMethod? = nil) {
        guard let deliveryVC else { print("Error: Top view controller is not DeliveryVC"); return }
        if let addressName { deliveryVC.updateAddress(addressName) }
        if let paymentMethod { deliveryVC.updatePaymentMethodUI(paymentMethod) }
    }
}
