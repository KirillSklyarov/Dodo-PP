import UIKit

enum MainCoordinatorEvent {
    case showProfile
    case showCart
    case showAddress
    case showStories(IndexPath)
    case showItemDetails
    case showError
}

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let moduleFactory: any MainModuleFactoryProtocol
    private var features: [FeatureType: Bool] = [:]

    private var mainVC: UIViewController?

    var onShowCart: (() -> Void)?
    var onShowProfile: (() -> Void)?
    var onShowAddress: (() -> Void)?

    // MARK: - Init
    init(router: Router, moduleFactory: any MainModuleFactoryProtocol, storage: FeatureToggleStorage) {
        self.router = router
        self.moduleFactory = moduleFactory
        getFeaturesFromStorage(storage)
    }

    deinit {
        print("MainCoordinator deinit")
    }
}

// MARK: - Start
extension MainCoordinator {
    func start() {
        prepareForShow()
    }

    // Показывает главный экран
    func showMainScreen() {
        guard let mainVC else { print("MainVC is nil"); return }
        router.setRootModule(mainVC) // Устанавливаем как главный и показываем его
    }

    // Вызываем обновление корзины на главном экране
    func mainVCUpdateCart() {
        if let vc = router.getMainViewController() {
            let presenter = vc.output
            presenter.sendAction(.updateCart)
        }
    }
}

// MARK: - Show Main Screen
private extension MainCoordinator {
    // Подготавливает экран для показа (но не показывает его - нужно чтобы обновились все данные)
    func prepareForShow() {
        guard let mainVC = moduleFactory.makeModule(for: .main) as? MainViewController else { return } // Создаем экран
        self.mainVC = mainVC
        let presenter = mainVC.output

        presenter.coordinatorEventHandler = { [weak self, weak presenter] event in
            guard let self else { return }
            switch event {
            case .showCart: checkFeatureToggleAndShowFlow(.cart, presenter: presenter!)
            case .showProfile: onShowProfile?()
            case .showAddress: onShowAddress?()
            case .showStories(let indexPath): showStories(indexPath)
            case .showItemDetails: checkFeatureToggleAndShowFlow(.productDetails, presenter: presenter!)
            case .showError: showMainAlert()
            }
        }
    }
}

// MARK: - Product details
private extension MainCoordinator {
    // Показ экрана деталей товара и связанные с ним операции
    func showProductDetails() {
        guard let vc = moduleFactory.makeModule(for: .itemDetails) as? ItemDetailsViewController else { return }  // Создаем экран
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .dismissModule: router.dismiss()
            case .showError: showItemDetailsError()
            case .showPopupVC(let popUpView): showPopupVC(popUpView)
            }
        }

        router.present(vc, modalPresentation: .fullScreen) // Показываем экран

    }

    // Показываем экран с КБЖУ
    func showPopupVC(_ popUpView: CpfcPopupView) {
        router.present(popUpView, modalPresentation: .popover)
    }

    // Показываем алёрт с Ошибкой
    func showItemDetailsError() {
        let vc = moduleFactory.makeErrorAlert(for: .itemDetails) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
    }
}

// MARK: - Stories
private extension MainCoordinator {
    func showStories(_ indexPath: IndexPath) {
        guard let vc = moduleFactory.makeModule(for: .stories(indexPath)) as? StoriesViewController else { print("Error: couldn't instantiate StoriesViewController"); return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule: dismissStories()
            case .showErrorAlert: showStoriesErrorAlert()
            }
        }

        router.present(vc, modalPresentation: .fullScreen) // Показываем экран
    }

    // Когда экран сторис закрыт, то обновляем сторисы на главном экране и закрываем окно
    func dismissStories() {
        mainVCUpdateStories() // Обновляем сторисы на главном экране
        router.dismiss() // Закрываем окно
    }

    func showStoriesErrorAlert() {
        let vc = moduleFactory.makeErrorAlert(for: .stories) { [weak self] in
            self?.router.dismiss() }
        router.present(vc)
    }
}

// MARK: - Alert
private extension MainCoordinator {
    // Создаем экран алерта (нужен когда фича выключена) и показываем его
    func showMainAlert() {
        let vc = moduleFactory.makeErrorAlert(for: .main) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
    }

    func showStoriesAlert() {
        let vc = moduleFactory.makeErrorAlert(for: .stories) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
    }

    func showProductDetailsAlert() {
        let vc = moduleFactory.makeErrorAlert(for: .itemDetails) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
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
    func checkFeatureToggleAndShowFlow(_ type: FeatureType, presenter: any MainViewControllerOutput) {

#if DEBUG
        switch type {
        case .cart: checkFeatureToggleAndShowCartFlow()
        case .productDetails: checkFeatureToggleAndShowProductDetailsScreen()
        case .profile: break
        }
#else
        switch type {
        case .profile: onShowProfile?()
        case .cart: onShowCart?()
        case .productDetails: showProductDetails()
        }
#endif
    }

    // Проверяем (на всякий случай) есть ли в словаре фичей такая позиция. Если есть и у нее статус false (запретить фичу), то показываем алерт, если true (разрешить фичу) - то вызываем замыкание onShowCart. Если же в словаре такой фичи нет (чего не должно быть, но лучше проверить), то тогда просто вызываем замыкание onShowCart (это стандартная дорога приложения)
    func checkFeatureToggleAndShowCartFlow() {
        if let feature = features[.cart] {
            feature ? onShowCart?() : showStoriesAlert()
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
