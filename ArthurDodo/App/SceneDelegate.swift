import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let storage = DataStorage.shared
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let navigationController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: navigationController, storage: storage)
        self.appCoordinator = appCoordinator
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appCoordinator.start()
    }
}
