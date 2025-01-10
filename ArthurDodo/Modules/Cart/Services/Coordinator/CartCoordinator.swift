import UIKit

enum CartCoordinatorEvent {
    case dismissModule
    case showEditProductModule
    case showPromoModule
    case showDeliveryModule
    case showCartErrorAlertModule
}

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let moduleFactory: CartModuleFactoryProtocol

    var onFinishFlow: (() -> Void)?
    var onCartDismissed: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: CartModuleFactoryProtocol) {
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
        let cartVC = moduleFactory.makeCartModule() // Создаем экран
        let presenter = cartVC.output

        presenter.coordinatorEventHandler = { [weak self] coordinatorEvent in
            switch coordinatorEvent {
            case .dismissModule: self?.dismissModule()
            case .showEditProductModule: self?.showEditProductVC()
            case .showPromoModule: self?.showPromoScreen()
            case .showDeliveryModule: self?.onFinishFlow?()
            case .showCartErrorAlertModule: self?.showCartErrorAlertModule()
            }
        }
        router.present(cartVC) // Показываем экран модально
    }
}

// MARK: - Supporting methods
private extension CartCoordinator {
        // Отрабатываем замыкания
    func dismissModule() {
        router.dismiss()
        onCartDismissed?()
    }

    // FIXME: НУЖНО ДОБИТЬ ЭТУ ЧАСТЬ
    func showEditProductVC() {
        //        presenter.onShowEditProductVC = { [weak self, weak viewModel] in
        //            self?.showEditProduct {
        //                viewModel?.sendAction(.updateCart) // При вызове комплишена мы обновляем корзину на экране
        //            }
        //        }
    }

    // Показываем всплывающий экран для акций
    func showPromoScreen() {
        let vc = moduleFactory.makePromoModule()
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        router.present(vc)
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showCartErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .profile) { [weak self] in
            self?.dismissModule()
        }

        router.present(vc)
    }
}

// MARK: - Supporting methods
private extension CartCoordinator {
    func showEditProduct(completion: @escaping (() -> Void)) {
        let vc = moduleFactory.makeEditItemModule() // Создаем экран
        let viewModel = vc.getViewModel()

        // Настраиваем замыкания
        viewModel.onCartButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil: showEditProduct vc.onCartButtonTapped"); return }
            completion() // Вызываем комплишн
            router.dismiss() // Закрываем текущий экран
        }

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss() // Закрываем текущий экран
        }

        // Показываем всплывающий экран с КБЖУ
        viewModel.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, modalPresentation: .popover)
        }

        // Показываем экран
        router.present(vc)
    }
}
