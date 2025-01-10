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
        let viewModel = vc.getViewModel()
        self.deliveryVC = vc

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
            self?.onDismissed?()
        }

        viewModel.onShowChooseAddress = { [weak self] in
            self?.showChooseAddress(vc)
        }

        viewModel.onShowChoosePaymentMethod = { [weak self] in
            self?.showChoosePaymentMethod(vc)
        }

        viewModel.onShowFinalVC = { [weak self] in
            self?.showFinalVC(parentVC: vc)
        }

        router.present(vc)
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    func showChooseAddress(_ parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeChooseAddressScreen()
        let viewModel = vc.getViewModel()
        router.present(vc)

        // Нажали на закрыть окно
        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        // Выбрали ячейку
        viewModel.onAddressCellTapped = { [weak self] addressName in
            self?.updateUI(addressName: addressName)
        }

        // Нажали на редактирование адреса
        viewModel.onEditAddressCellTapped = { [weak self] address in
            self?.showEditAddressVC(vc)
        }

        // Нажали на добавить новый адрес
        viewModel.onShowAddNewAddress = { [weak self] in
            self?.showAddNewAddressVC(vc)
        }
    }

    func showEditAddressVC(_ parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeEditAddressScreen()
        let viewModel = vc.getViewModel()

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        viewModel.onSaveButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        router.present(vc, modalPresentation: .fullScreen)
    }

    func showAddNewAddressVC(_ parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeAddNewAddressScreen()
        let viewModel = vc.getViewModel()

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        viewModel.onSaveNewAddressButtonTapped = { [weak self] in
            self?.router.dismiss()
        }
        
        router.present(vc, modalPresentation: .fullScreen)
    }

    func showChoosePaymentMethod(_ parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeChoosePaymentMethodScreen()
        let viewModel = vc.getViewModel()
        router.present(vc)

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        viewModel.onPaymentMethodSelected = { [weak self] paymentMethod in
            self?.updateUI(paymentMethod: paymentMethod)
            self?.router.dismiss()
        }
    }

    // Показываем финальный экран
    func showFinalVC(parentVC: UIViewController) {
        let vc = screenFactory.deliveryScreenFactory.makeFinalVCScreen()
        let viewModel = vc.getViewModel()

        viewModel.onFinalVCDismissed = { [weak self] in
            self?.router.dismiss()
            self?.onFinishFlow?()
        }

        router.present(vc)
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
