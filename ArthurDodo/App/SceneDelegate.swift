import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let storage = DataStorage.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let navigationController = UINavigationController()
        let router = AppRouter(navigationController: navigationController, storage: storage)
        router.navigate(to: .main)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
