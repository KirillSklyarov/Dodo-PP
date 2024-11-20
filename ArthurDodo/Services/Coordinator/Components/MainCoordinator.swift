import UIKit

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory
    private var mainVC: MainViewController?

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

    func start() {
        let mainVC = screenFactory.makeMainScreen() // Создаем экран
        self.mainVC = mainVC

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
}

// MARK: - Product details
private extension MainCoordinator {
    // Показ экрана деталей товара и связанные с ним операции
    func showProductDetails() {
        let vc = screenFactory.makeProductDetailsScreen() // Создаем экран

        // Настраиваем замыкания
        vc.onCartButtonTapped = { [weak self] in
            self?.mainVC?.updateUI()
        }

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        vc.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, parentVC: true, modalPresentation: .popover)
        }

        router.present(vc) // Показываем экран

    }

    func showStories(_ indexPath: IndexPath) {
        let vc = screenFactory.makeStoriesScreen(indexPath: indexPath)
        router.present(vc)
        vc.onStoriesVCDismissed = { [weak self] in
            self?.mainVC?.updateUI()
        }

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }
    }
}
