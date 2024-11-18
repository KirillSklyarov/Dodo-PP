import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let di = DependencyContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = di.router.setRootNavigation()
        window?.makeKeyAndVisible()

        let appCoordinator = di.appCoordinator
        appCoordinator.start()

        resetActiveOrder() // Сбрасывает активный заказ (использую для тестирования)

    }

    // Метод сбрасывает активный заказ для отладки,
    private func resetActiveOrder() {
        UserDefaults.standard.resetActiveOrder()
    }
}
