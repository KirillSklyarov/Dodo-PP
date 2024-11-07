import UIKit

final class MainCoordinator: Coordinator {

    // MARK: - Properties
    var storage: DataStorage
    var navigationController: UINavigationController
    var callback: ((UIViewController) -> Void)?
    weak var viewController: MainViewController?
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(storage: DataStorage, navigationController: UINavigationController) {
        self.storage = storage
        self.navigationController = navigationController
    }

    deinit {
        print("MainCoordinator deinit")
    }
}

// MARK: - Public methods
extension MainCoordinator {
    func start() {
//        let vc = MainViewController(storage: storage)
//        viewController = vc
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
    }

    func showProfile() {
        let profileCoordinator = ProfileCoordinator(storage: storage, navigationController: navigationController)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }

    func showProductDetails() {
//        let vc = ProductDetailsViewController(storage: storage)
//        vc.coordinator = self
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//
//        vc.onCartButtonTapped = { [weak self] in
//            guard let self else { print("Self is nil, can't set price"); return }
//            viewController?.updateCart()
//        }
    }

    func showStories(_ indexPath: IndexPath) {
//        let vc = StoriesVC()
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.present(vc, animated: true)
//        vc.showStories(indexPath)
//
//        vc.onStoriesVCDismissed = { [weak self] in
//            self?.viewController?.updateUI()
//        }
    }

    func showAddress() {
        let addressCoordinator = AddressCoordinator(storage: storage, navigationController: navigationController)
        childCoordinators.append(addressCoordinator)
        addressCoordinator.parentCoordinator = self
        addressCoordinator.start()
    }

    func showCart() {
        let cartCoordinator = CartCoordinator(storage: storage, navigationController: navigationController)
        cartCoordinator.parentCoordinator = self
        childCoordinators.append(cartCoordinator)
        cartCoordinator.start()
    }

    func showPopUpView(_ popUpView: CpfcPopupView?) {
        guard let popUpView else { print("PopUpView is nil"); return }
        navigationController.visibleViewController?.present(popUpView, animated: true)
    }
}
