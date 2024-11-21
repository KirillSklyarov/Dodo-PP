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

    func start() {
        let cartVC = screenFactory.makeCartScreen() // Создаем экран

        // Отрабатываем замыкания
        cartVC.onCartVCDismissed = { [weak self] in
            guard let self else { return }
            onCartDismissed?()
            router.dismiss()
        }

        cartVC.onShowEditProductVC = { [weak self, weak cartVC] in
            self?.showEditProduct {
                cartVC?.updateCart() // При вызове комплишна мы обновляем корзину на экране
            }
        }

        cartVC.onShowPromoVC = { [weak self] promo in
            self?.showApplySpecialOffer(promo)
        }

        cartVC.onShowDeliveryVC = { [weak self] in
            self?.onFinishFlow?()
        }

//        router.present(cartVC, isParentVC: true, modalPresentation: .automatic) // Показываем экран модульно

        router.setRootModule(cartVC, animation: true)
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
            router.dismiss() // Закрываем текущий экран
        }

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss() // Закрываем текущий экран
        }

        // Показываем всплывающий экран с КБЖУ
        vc.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, isParentVC: true, modalPresentation: .popover)
        }

        // Показываем экран
        router.present(vc, modalPresentation: .automatic)
    }

    // Показываем всплывающий экран для акций
    func showApplySpecialOffer(_ offer: Promo) {
        let vc = screenFactory.makeApplySpecialOfferScreen(offer)
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        router.present(vc, modalPresentation: .automatic)
    }
}
