import UIKit

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: MainScreenFactoryProtocol
    private var features: [FeatureType: Bool] = [:]

    var onShowCart: (() -> Void)?
    var onShowProfile: (() -> Void)?
    var onShowAddress: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: MainScreenFactoryProtocol, storage: FeatureToggleStorage) {
        self.router = router
        self.screenFactory = screenFactory
        getFeaturesFromStorage(storage)
    }

    deinit {
        print("MainCoordinator deinit")
    }
}

// MARK: - Start
extension MainCoordinator {
    func start() {
        let mainVC = screenFactory.makeMainScreen() // Создаем экран
        var viewModel = mainVC.getViewModel()

        // Настраиваем замыкания
        viewModel.onProfileButtonTapped = { [weak self] in
            self?.checkFeatureToggleAndShowFlow(.profile)
        }

        viewModel.onAddressButtonTapped = { [weak self] in
            self?.onShowAddress?()
        }

        viewModel.onStoryTapped = { [weak self] indexPath in
            self?.showStories(indexPath)
        }

        viewModel.onProductDetailsTapped = { [weak self] in
            self?.checkFeatureToggleAndShowFlow(.productDetails)
        }

        viewModel.onCartButtonTapped = { [weak self] in
            self?.checkFeatureToggleAndShowFlow(.cart)
        }

        router.setRootModule(mainVC) // Устанавливаем как главный и показываем его
    }

    // Вызываем обновление корзины на главном экране
    func mainVCUpdateCart() {
        if let vc = router.getMainViewController() {
            let viewModel = vc.getViewModel()
            viewModel.updateCart()
//            vc.presenter.updateCart()
        }
    }
}

// MARK: - Product details
private extension MainCoordinator {
    // Показ экрана деталей товара и связанные с ним операции
    func showProductDetails() {
        let vc = screenFactory.makeProductDetailsScreen() // Создаем экран
        var viewModel = vc.getViewModel()

        // Настраиваем замыкания
        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
        }

        viewModel.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(popUpView, isParent: true, modalPresentation: .popover)
        }

        router.present(vc, isParent: true , modalPresentation: .fullScreen) // Показываем экран
    }
}

// MARK: - Stories
private extension MainCoordinator {
    func showStories(_ indexPath: IndexPath) {
        let vc = screenFactory.makeStoriesScreen(indexPath: indexPath)
        var viewModel = vc.getViewModel()

        // Когда экран сторис закрыт, то обновляем сторисы на главном экране и закрываем окно
        viewModel.onDismissed = { [weak self] in
            self?.mainVCUpdateStories() // Обновляем сторисы на главном экране
            self?.router.dismiss() // Закрываем окно
        }

        router.present(vc, modalPresentation: .fullScreen) // Показываем экран
    }
}

// MARK: - Alert
private extension MainCoordinator {
    // Создаем экран алерта (нужен когда фича выключена) и показываем его
    func showProfileAlert() {
        let vc = screenFactory.makeAlertScreen(.profile)
        router.present(vc, isParent: true)
    }

    func showCartAlert() {
        let vc = screenFactory.makeAlertScreen(.cart)
        router.present(vc, isParent: true)
    }

    func showProductDetailsAlert() {
        let vc = screenFactory.makeAlertScreen(.productDetails)
        router.present(vc, isParent: true)
    }
}

// MARK: - Supporting methods
private extension MainCoordinator {
    // Получаем из хранилища словарь фичей
    func getFeaturesFromStorage(_ storage: FeatureToggleStorage) {
        features = storage.getFeatures()
    }

    // Находит в стеке родительский экран и вызывает обновление сторисов
    func mainVCUpdateStories() {
        if let mainVC = router.getMainViewController() {
            mainVC.updateStories()
        }
    }
}

// MARK: - FeatureToggles
private extension MainCoordinator {
    func checkFeatureToggleAndShowFlow(_ type: FeatureType) {

#if DEBUG
        switch type {
        case .profile: checkFeatureToggleAndShowProfileFlow()
        case .cart: checkFeatureToggleAndShowCartFlow()
        case .productDetails: checkFeatureToggleAndShowProductDetailsScreen()
        }
#else
        switch type {
        case .profile: onShowProfile?()
        case .cart: onShowCart?()
        case .productDetails:  showProductDetails()
        }
#endif
    }

    // Проверяем (на всякий случай) есть ли в словаре фичей такая позиция. Если есть и у нее статус false (запретить фичу), то показываем алерт, если true (разрешить фичу) - то вызываем замыкание onShowProfile (это стандартная дорога приложения). Если же в словаре такой фичи нет (чего не должно быть, но лучше проверить), то тогда просто вызываем замыкание onShowProfile.
    func checkFeatureToggleAndShowProfileFlow() {
        if let feature = features[.profile] {
            feature ? onShowProfile?() : showProfileAlert()
        } else {
            print("No feature toggle for profile")
            onShowProfile?()
        }
    }

    // Проверяем (на всякий случай) есть ли в словаре фичей такая позиция. Если есть и у нее статус false (запретить фичу), то показываем алерт, если true (разрешить фичу) - то вызываем замыкание onShowCart. Если же в словаре такой фичи нет (чего не должно быть, но лучше проверить), то тогда просто вызываем замыкание onShowCart (это стандартная дорога приложения)
    func checkFeatureToggleAndShowCartFlow() {
        if let feature = features[.cart] {
            feature ? onShowCart?() : showCartAlert()
        } else {
            print("No feature toggle for cart")
            onShowCart?()
        }
    }

    func checkFeatureToggleAndShowProductDetailsScreen() {
        if let feature = features[.productDetails] {
            feature ? showProductDetails() : showProductDetailsAlert()
        } else {
            print("No feature toggle for product details")
            showProductDetails()
        }
    }
}
