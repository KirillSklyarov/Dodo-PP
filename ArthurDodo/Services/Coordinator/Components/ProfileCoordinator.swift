import UIKit

final class ProfileCoordinator: Coordinator {

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
extension ProfileCoordinator {
    func start() {
//        let vc = ProfileViewController(storage: storage)
//        vc.coordinator = self
//        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showChatAlert() {
        let vc = CustomActionSheet()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController.visibleViewController?.present(vc, animated: false)
    }

    func showPersonalData() {
        let personalDataVC = PersonalViewController()
        let vc = UINavigationController(rootViewController: personalDataVC)
        navigationController.visibleViewController?.present(vc, animated: true)
    }

    func showApplySpecialOffer(_ offer: Promo) {
//        let vc = ApplyOfferViewController()
//        guard let configureSheet = vc.sheetPresentationController else { return }
//        configureSheet.detents = [.medium()]
//        configureSheet.prefersGrabberVisible = true
//        navigationController.visibleViewController?.present(vc, animated: true)
//        vc.configureViewController(offer)
    }
}
