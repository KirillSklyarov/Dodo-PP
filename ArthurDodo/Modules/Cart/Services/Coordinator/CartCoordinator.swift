import UIKit

enum CartCoordinatorEvent {
    case dismissModule
    case showPromoModule
    case showDeliveryModule
    case showCartErrorAlertModule
    case showEditProductModule
}

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let moduleFactory: any CartModuleFactoryProtocol

    var onFinishFlow: (() -> Void)?
    var onCartDismissed: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: any CartModuleFactoryProtocol) {
        self.router = router
        self.moduleFactory = screenFactory
    }

    deinit {
        print("CartCoordinator deinit")
    }
}

// MARK: - Start
extension CartCoordinator {
    func start() {
        guard let cartVC = moduleFactory.makeModule(for: .cart) as? CartViewController else { return } // Создаем и кастим экран
        let presenter = cartVC.output

        // Coordinator Event handler
        presenter.coordinatorEventHandler = { [weak self, weak presenter] coordinatorEvent in
            guard let self else { return }
            switch coordinatorEvent {
            case .dismissModule: dismissModule()
            case .showPromoModule: showPromoScreen()
            case .showDeliveryModule: onFinishFlow?()
            case .showCartErrorAlertModule: showCartErrorAlertModule()
            case .showEditProductModule: showEditItemModule(presenter!)
            }
        }

        router.present(cartVC) // Показываем экран модально
    }
}

// MARK: - Supporting methods
private extension CartCoordinator {
    // Закрываем модуль
    func dismissModule() {
        router.dismiss()
        onCartDismissed?()
    }

    // Показываем всплывающий экран для акций
    func showPromoScreen() {
        let vc = moduleFactory.makeModule(for: .promo)
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        router.present(vc)
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showCartErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .cartError) { [weak self] in
            self?.dismissModule()
        }

        router.present(vc)
    }
}

// MARK: - EditItemModule
private extension CartCoordinator {
    // Показываем экран с редактированием товара. Комплишн здесь нужен, чтобы когда закрывался экран с редактированием у нас обновлялась корзина
    func showEditItemModule(_ presenter: any CartViewControllerOutput) {
        showEditProductVC() { [weak presenter] in
            presenter?.sendAction(.updateCart) // При вызове комплишена мы обновляем корзину на экране
        }
    }

    // Создаем экран редактирования и настраиваем Coordinator Event handler
    func showEditProductVC(completion: @escaping (() -> Void)) {
        guard let vc = moduleFactory.makeModule(for: .editProduct) as? EditItemViewController else { return } // Создаем и кастим экран
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] coordinatorEvent in
            guard let self else { return }
            switch coordinatorEvent {
            case .dismissModule: router.dismiss()
            case .showEditItemErrorAlertModule: showEditItemErrorAlertModule()
            case .cartButtonTapped: dismissModuleAndUpdateCart(completion)
            case .showPopupView(let popUpVC): showPopupView(popUpVC)
            }
        }

        router.present(vc)
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showEditItemErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .editItemError) { [weak self] in
            self?.dismissModule()
        }

        router.present(vc)
    }

    // Когда нажимаем на кнопку корзины, то вызываем замыкание, которое обновляет корзину на предыдущем экране и закрывает этот
    func dismissModuleAndUpdateCart(_ completion: @escaping () -> Void) {
        completion()
        router.dismiss()
    }

    // Показываем экран с КБЖУ
    func showPopupView(_ popUpVC: CpfcPopupView) {
        router.present(popUpVC, modalPresentation: .popover)
    }
}
