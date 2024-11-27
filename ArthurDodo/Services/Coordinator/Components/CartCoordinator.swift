import UIKit

final class CartCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory

    var onFinishFlow: (() -> Void)?
    var onCartDismissed: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("CartCoordinator deinit")
    }
}

extension CartCoordinator {
    func start() {
        let cartVC = screenFactory.makeCartScreen() // Создаем экран

        // Отрабатываем замыкания
        cartVC.onCartVCDismissed = { [weak self] in
            guard let self else { return }
            router.dismiss()
            onCartDismissed?()
        }

        cartVC.onShowEditProductVC = { [weak self, weak cartVC] in
            self?.showEditProduct {
                cartVC?.updateCart() // При вызове комплишена мы обновляем корзину на экране
            }
        }

        cartVC.onShowPromoVC = { [weak self] promo in
            self?.showApplySpecialOffer(promo)
        }

        cartVC.onShowDeliveryVC = { [weak self] in
            self?.onFinishFlow?()
        }

        router.present(cartVC) // Показываем экран модально
    }
}

// MARK: - Supporting methods
private extension CartCoordinator {
    func showEditProduct(completion: @escaping (() -> Void)) {
        let vc = screenFactory.makeEditProductScreen() // Создаем экран

        // Настраиваем замыкания
        vc.onCartButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil: showEditProduct vc.onCartButtonTapped"); return }
            completion() // Вызываем комплишн
            router.dismiss(isParent: true) // Закрываем текущий экран
        }

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true) // Закрываем текущий экран
        }

        // Показываем всплывающий экран с КБЖУ
        vc.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, isParent: true, modalPresentation: .popover)
        }

        // Показываем экран
        router.present(vc, isParent: true)
    }

    // Показываем всплывающий экран для акций
    func showApplySpecialOffer(_ offer: Promo) {
        let vc = screenFactory.makeApplySpecialOfferScreen(offer)
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        router.present(vc, isParent: true)
    }
}
