import UIKit

enum DeliveryCoordinatorEvent {
    case dismissModule
    case showDeliveryErrorAlertModule
    case showChooseAddress
    case showChoosePaymentMethod
    case showFinal
}

final class DeliveryCoordinator: Coordinator {

    // MARK: - Properties
    private let moduleFactory: DeliveryModuleFactory
    private let router: Router
    private var deliveryVC: DeliveryViewController?

    var onFinishFlow: (() -> Void)?
    var onDismissed: (() -> Void)?

    // MARK: - Init
    init(moduleFactory: DeliveryModuleFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.router = router
    }

    deinit {
        print("DeliveryCoordinator deinit")
    }
}

// MARK: - Start
extension DeliveryCoordinator {
    func start() {
        guard let vc = moduleFactory.makeModule(for: .delivery) as? DeliveryViewController else { return }
        let presenter = vc.output

        self.deliveryVC = vc

        presenter.coordinatorEventHandler = { [weak self] coordinatorEvent in
            guard let self else { return }
            switch coordinatorEvent {
            case .dismissModule: dismissModule()
            case .showDeliveryErrorAlertModule: showDeliveryErrorAlertModule()
            case .showChooseAddress: showChooseAddress()
            case .showChoosePaymentMethod: showChoosePaymentMethod()
            case .showFinal: showFinalVC()
            }
        }

        router.present(vc)
    }

    // Закрываем экран и говорим предыдущему координатору что мы закрылись (этот процесс будет отличаться от onFinishFlow)
    func dismissModule() {
        router.dismiss()
        onDismissed?()
    }

    // Показываем алёрт с ошибкой и при нажатии на кнопку на алёрте закрываем окно
    func showDeliveryErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .deliveryError) {
            self.dismissModule()
        }
        router.present(vc)
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    func showChooseAddress() {
        guard let vc = moduleFactory.makeModule(for: .chooseAddress) as? ChooseAddressVC else { return }
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
        guard let vc = moduleFactory.makeModule(for: .editAddress) as? EditAddressViewController else { return }

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
        guard let vc = moduleFactory.makeModule(for: .addNewAddress) as? AddNewAddressViewController else { return }
        let viewModel = vc.getViewModel()

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        viewModel.onSaveNewAddressButtonTapped = { [weak self] in
            self?.router.dismiss()
        }
        
        router.present(vc, modalPresentation: .fullScreen)
    }

    func showChoosePaymentMethod() {
       guard let vc = moduleFactory.makeModule(for: .choosePaymentMethod) as? ChoosePaymentMethodVC else { return }
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
    func showFinalVC() {
        guard let vc = moduleFactory.makeModule(for: .final) as? FinalVC else { return }
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
