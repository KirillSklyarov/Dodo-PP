import UIKit
import AppUIComponentsSPM

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let di = DependencyContainer()
    private var appStartManager: AppStartManager?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        FontManager.setupFonts()

        setupAppStartManager()
        setupAppCoordinator()
        startApp()

//        resetActiveOrder() // Сбрасывает активный заказ (использую для тестирования)
        resetViewedStories() // Сбрасывает просмотренные сторисы
    }
}

// MARK: - Supporting methods
private extension SceneDelegate {
    // Настраиваем appStartManager
    private func setupAppStartManager() {
        appStartManager = di.appStartManager
        appStartManager?.setWindow(window)
    }

    // Настраиваем appCoordinator (нужен, чтобы потом приложение нормально двигалось по разным flow)
    private func setupAppCoordinator() {
        appCoordinator = appStartManager?.getAppCoordinator()
    }

    // Стартуем приложение (из appStartManager)
    private func startApp() {
        appStartManager?.startApp()
    }

    // Метод сбрасывает активный заказ для отладки,
    private func resetActiveOrder() {
        UserDefaults.standard.resetActiveOrder()
    }

    // Сбрасывает просмотренные сторисы (использую для тестирования)
    private func resetViewedStories() {
        UserDefaults.standard.resetViewedStories()
    }
}
