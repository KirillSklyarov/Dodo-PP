import UIKit

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory

    var onShowCart: (() -> Void)?
    var onShowProfile: (() -> Void)?
    var onShowAddress: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("MainCoordinator deinit")
    }
}

// MARK: - Start
extension MainCoordinator {
    func start() {
        let mainVC = screenFactory.makeMainScreen() // Создаем экран

        // Настраиваем замыкания
        mainVC.onProfileButtonTapped = { [weak self] in
            self?.onShowProfile?()
        }

        mainVC.onAddressButtonTapped = { [weak self] in
            self?.onShowAddress?()
        }

        mainVC.onStoryTapped = { [weak self] indexPath in
            self?.showStories(indexPath)
        }

        mainVC.onProductDetailsTapped = { [weak self] in
            self?.showProductDetails()
        }

        mainVC.onCartButtonTapped = { [weak self] in
            self?.onShowCart?()
        }

        router.setRootModule(mainVC) // Устанавливаем как главный и показываем его
    }

    // Вызываем обновление корзины на главном экране
    func mainVCUpdateCart() {
        if let vc = router.getMainViewController() {
            vc.updateCart()
        }
    }
}

// MARK: - Product details
private extension MainCoordinator {
    // Показ экрана деталей товара и связанные с ним операции
    func showProductDetails() {
        let vc = screenFactory.makeProductDetailsScreen() // Создаем экран

        // Настраиваем замыкания
        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        vc.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, isParent: true, modalPresentation: .popover)
        }

        router.present(vc, isParent: true , modalPresentation: .fullScreen) // Показываем экран
    }
}

// MARK: - Stories
private extension MainCoordinator {
    func showStories(_ indexPath: IndexPath) {
        let vc = screenFactory.makeStoriesScreen(indexPath: indexPath)

        // Когда экран сторис закрыт, то обновляем сторисы на главном экране и закрываем окно
        vc.onDismissed = { [weak self] in
            self?.mainVCUpdateStories() // Обновляем сторисы на главном экране
            self?.router.dismiss() // Закрываем окно
        }

        router.present(vc, modalPresentation: .fullScreen) // Показываем экран
    }
}

// MARK: - Supporting methods
private extension MainCoordinator {
    // Находит в стеке родительский экран и вызывает обновление сторисов
    func mainVCUpdateStories() {
        if let mainVC = router.getMainViewController() {
            mainVC.updateStories()
        }
    }
}
