import UIKit

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let screenFactory: CartScreenFactory

    var onFinishFlow: (() -> Void)?
    var onCartDismissed: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: CartScreenFactory) {
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
        let presenter = cartVC.presenter

        // Отрабатываем замыкания
        presenter.onCartVCDismissed = { [weak self] in
            guard let self else { return }
            router.dismiss()
            onCartDismissed?()
        }

        presenter.onShowEditProductVC = { [weak self, weak presenter] in
            self?.showEditProduct {
                presenter?.updateCart() // При вызове комплишена мы обновляем корзину на экране
            }
        }

        presenter.onShowPromoVC = { [weak self] promo in
            self?.showPromoScreen(promo)
        }

        presenter.onShowDeliveryVC = { [weak self] in
            self?.onFinishFlow?()
        }

        router.present(cartVC) // Показываем экран модально
    }
}

// MARK: - Supporting methods
private extension CartCoordinator {
    func showEditProduct(completion: @escaping (() -> Void)) {
        let vc = screenFactory.makeEditProductScreen() // Создаем экран
        let presenter = vc.presenter

        // Настраиваем замыкания
        presenter.onCartButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil: showEditProduct vc.onCartButtonTapped"); return }
            completion() // Вызываем комплишн
            router.dismiss(isParent: true) // Закрываем текущий экран
        }

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true) // Закрываем текущий экран
        }

        // Показываем всплывающий экран с КБЖУ
        presenter.onShowPopupVC = { [weak self] popUpView in
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
