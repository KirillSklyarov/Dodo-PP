import UIKit

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let screenFactory: CartScreenFactoryProtocol

    var onFinishFlow: (() -> Void)?
    var onCartDismissed: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: CartScreenFactoryProtocol) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("CartCoordinator deinit")
    }
}

// MARK: - Start
extension CartCoordinator {
    func start() {
        let cartVC = screenFactory.makeCartScreen() // Создаем экран
        let viewModel = cartVC.getViewModel()

        // Отрабатываем замыкания
        viewModel.onCartVCDismissed = { [weak self] in
            guard let self else { return }
            router.dismiss()
            onCartDismissed?()
        }

        viewModel.onShowEditProductVC = { [weak self, weak viewModel] in
            self?.showEditProduct {
                viewModel?.updateCart() // При вызове комплишена мы обновляем корзину на экране
            }
        }

        viewModel.onShowPromoVC = { [weak self] promo in
            self?.showPromoScreen(promo)
        }

        viewModel.onShowDeliveryVC = { [weak self] in
            self?.onFinishFlow?()
        }

        router.present(cartVC) // Показываем экран модально
    }
}

// MARK: - Supporting methods
private extension CartCoordinator {
    func showEditProduct(completion: @escaping (() -> Void)) {
        let vc = screenFactory.makeEditProductScreen() // Создаем экран
        var viewModel = vc.getViewModel()

        // Настраиваем замыкания
        viewModel.onCartButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil: showEditProduct vc.onCartButtonTapped"); return }
            completion() // Вызываем комплишн
            router.dismiss(isParent: true) // Закрываем текущий экран
        }

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true) // Закрываем текущий экран
        }

        // Показываем всплывающий экран с КБЖУ
        viewModel.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, isParent: true, modalPresentation: .popover)
        }

        // Показываем экран
        router.present(vc, isParent: true)
    }

    // Показываем всплывающий экран для акций
    func showPromoScreen(_ offer: Promo) {
        let vc = screenFactory.makePromoScreen(offer)
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        router.present(vc, isParent: true)
    }
}
