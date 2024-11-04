import UIKit

final class ProfileRouter {

    // MARK: - Properties
    var storage: DataStorage
    var navigationController: UINavigationController

    // MARK: - Init
    init(storage: DataStorage, navigationController: UINavigationController) {
        self.storage = storage
        self.navigationController = navigationController
    }
}

// MARK: - Public methods
extension ProfileRouter {
    func goToProfile(router: AppRouter) {
        let vc = ProfileViewController(storage: storage, router: router)
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func goToChatAlert() {
        let vc = CustomActionSheet()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController.visibleViewController?.present(vc, animated: false)
    }

    func goToPersonalData() {
        let personalDataVC = PersonalViewController()
        let vc = UINavigationController(rootViewController: personalDataVC)
        navigationController.visibleViewController?.present(vc, animated: true)
    }
}
