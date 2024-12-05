import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let di = DependencyContainer()
    private var appCoordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        startAppBasedOnScheme()

        resetActiveOrder() // Сбрасывает активный заказ (использую для тестирования)
    }
}

// MARK: - Supporting methods
private extension SceneDelegate {
    // В зависимости от схемы либо показываем экран FeatureToggle (в схеме debug), либо идем по стандартной процедуре (делаем навигацию, AppCoordinanor, и стартуем приложение) (в схеме release)
    func startAppBasedOnScheme() {
#if DEBUG
        showFeatureToggles()
#else
        standardUserAppStart()
#endif
    }

    // Стандартный показ приложения для пользователей
    private func standardUserAppStart() {
        window?.rootViewController = di.router.setRootNavigation()
        window?.makeKeyAndVisible()
        setAppCoordinator()
        startApp()
    }

    // Показываем FeatureToggles (сначала фетчим все данные, потом показываем экран)
    private func showFeatureToggles() {
        Task {
            await di.featureToggleService.fetchAllFeatures()
            showFeatureTogglesVC()
        }
    }

    // Показывает FeatureToggles экран, а после нажатия на кнопку Start App приложeние начинает загружаться в обычном виде
    private func showFeatureTogglesVC() {
        let featureToggleVC = di.screenFactory.makeFeatureTogglesScreen()

        featureToggleVC.onStartButtonTapped = { [weak self] in
            guard let self else { return }
            standardUserAppStart()
        }

        window?.rootViewController = featureToggleVC
        window?.makeKeyAndVisible()
    }

    // Сначала загружаем данные с сервера, и только потом стартует главный координатор
    private func startApp() {
        Task {
            await di.startAppService.fetchAllData()
            appCoordinator?.start()
        }
    }

    // Назначаем основной координатор приложения
    private func setAppCoordinator() {
        appCoordinator = di.coordinatorFactory.makeAppCoordinator()
    }

    // Метод сбрасывает активный заказ для отладки,
    private func resetActiveOrder() {
        UserDefaults.standard.resetActiveOrder()
    }

    // Сбрасывает просмотренные сторисы (использую для тестирования)
    private func resetStories() {
        UserDefaults.standard.resetViewedStories()
    }
}
