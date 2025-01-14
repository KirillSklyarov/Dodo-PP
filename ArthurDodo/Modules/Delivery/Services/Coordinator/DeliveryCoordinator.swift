import UIKit

enum DeliveryCoordinatorEvent {
    case dismissModule
    case showDeliveryErrorAlertModule
    case showChooseAddress
    case showChoosePaymentMethod
    case showFinal
}

enum PaymentMethodCoordinatorEvent {
    case dismissModule
    case showPaymentMethodErrorAlertModule
    case paymentMethodSelected(PaymentMethod)
}

enum FinalViewCoordinatorEvent {
    case dismissModule
    case showFinalError
    case finishFlow
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
            case .showChooseAddress: showChooseAddressModule()
            case .showChoosePaymentMethod: showChoosePaymentMethod()
            case .showFinal: showFinalVC()
            }
        }

        router.present(vc)
    }
}

// MARK: - Modules creation
private extension DeliveryCoordinator {
    // Показываем экран с адресами и настраиваем Event Handler
    func showChooseAddressModule() {
        guard let vc = moduleFactory.makeModule(for: .chooseAddress) as? ChooseAddressViewController else { return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] coordinatorEvent in
            guard let self else { return }
            switch coordinatorEvent {
            case .dismissModule: router.dismiss()
            case .showAddressErrorAlert: showChooseAddressErrorAlertModule()
            case .addressSelected(let addressName): updateAddressName(with: addressName)
            }
        }

        router.present(vc)
    }

//    func showChooseAddress() {
//        guard let vc = moduleFactory.makeModule(for: .chooseAddress) as? ChooseAddressVC else { return }
//        let viewModel = vc.getViewModel()
//        router.present(vc)
//
//        // Нажали на закрыть окно
//        viewModel.onDismissButtonTapped = { [weak self] in
//            self?.router.dismiss()
//        }
//
//        // Выбрали ячейку
//        viewModel.onAddressCellTapped = { [weak self] addressName in
//            self?.updateUI(addressName: addressName)
//        }
//
//        // Нажали на редактирование адреса
//        viewModel.onEditAddressCellTapped = { [weak self] address in
//            self?.showEditAddressVC(vc)
//        }
//
//        // Нажали на добавить новый адрес
//        viewModel.onShowAddNewAddress = { [weak self] in
//            self?.showAddNewAddressVC(vc)
//        }
//    }

    func showEditAddressVC(_ parentVC: UIViewController) {
        guard let vc = moduleFactory.makeModule(for: .editAddress) as? EditAddressViewController else { return }

        guard let presenter = vc.output as? EditAddressPresenter else { return }

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule, .addressSaved: router.dismiss()
            case .showError: showEditAddressError()
            }
        }

        router.present(vc, modalPresentation: .fullScreen)
    }

    func showAddNewAddressVC(_ parentVC: UIViewController) {
        guard let vc = moduleFactory.makeModule(for: .addNewAddress) as? AddNewAddressViewController else { return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule, .addedNewAddress: router.dismiss()
            case .addNewAddressError: showAddNewAddressError()
            }
        }

        router.present(vc, modalPresentation: .fullScreen)
    }

    // Показываем экран с выбором метода оплаты и отрабатываем Event Handler
    func showChoosePaymentMethod() {
       guard let vc = moduleFactory.makeModule(for: .choosePaymentMethod) as? ChoosePaymentMethodVC else { return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule: router.dismiss()
            case .showPaymentMethodErrorAlertModule: showPaymentMethodErrorAlertModule()
            case .paymentMethodSelected(let paymentMethod): updatePaymentMethod(with: paymentMethod)
            }
        }

        router.present(vc)
    }

    // Показываем финальный экран
    func showFinalVC() {
        guard let vc = moduleFactory.makeModule(for: .final) as? FinalViewController else { return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule: finishFlow()
            case .showFinalError: showFinalErrorAlertModule()
            case .finishFlow: finishFlow()
            }
        }

        router.present(vc)
    }
}

// MARK: - Errors Alerts
private extension DeliveryCoordinator {
    // Показываем алёрт с ошибкой и при нажатии на кнопку на алёрте закрываем окно
    func showDeliveryErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .deliveryError) {
            self.dismissModule()
        }
        router.present(vc)
    }

    // Показываем алёрт с ошибкой и при нажатии на кнопку на алёрте закрываем окно
    func showChooseAddressErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .chooseAddress) {
            self.dismissModule()
        }
        router.present(vc)
    }

    // Показываем алёрт с ошибкой и при нажатии на кнопку на алёрте закрываем окно
    func showFinalErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .finalError) {
            self.finishFlow()
        }
        router.present(vc)
    }

    // Показываем алёрт с ошибкой и при нажатии на кнопку на алёрте закрываем окно
    func showPaymentMethodErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .paymentMethod) {
            self.router.dismiss()
        }
        router.present(vc)
    }

    func showEditAddressError() {
        let vc = moduleFactory.makeErrorAlert(for: .addressToEdit) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
    }

    func showAddNewAddressError() {
        let vc = moduleFactory.makeErrorAlert(for: .addNewAddress) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
    }
}

// MARK: - Supporting methods
private extension DeliveryCoordinator {
    // Закрываем экран и говорим предыдущему координатору что мы закрылись (этот процесс будет отличаться от onFinishFlow)
    func dismissModule() {
        router.dismiss()
        onDismissed?()
    }

    // Метод завершает flow
    func finishFlow() {
        router.dismissAll()
        onFinishFlow?()
    }

    // Когда юзер выбрал адрес, то мы закрываем экран на экране доставки обновляем адрес доставки
    func updateAddressName(with addressName: String) {
        router.dismiss()
        updateUI(addressName: addressName)
    }

    // Когда юзер выбрал способ оплаты, то мы закрываем экран на экране доставки обновляем способ оплаты
    func updatePaymentMethod(with paymentMethod: PaymentMethod) {
        router.dismiss()
        updateUI(paymentMethod: paymentMethod)
    }

    // Обновляет данные на главном экране этого потока (в данном случае экрана "Доставка"). Сначала находим верхний экран, потом обновляем те данные, которые не nil.
    func updateUI(addressName: String? = nil, paymentMethod: PaymentMethod? = nil) {
        guard let deliveryVC else { print("Error: Top view controller is not DeliveryVC"); return }
        if let addressName { deliveryVC.updateAddress(addressName) }
        if let paymentMethod { deliveryVC.updatePaymentMethodUI(paymentMethod) }
    }
}
