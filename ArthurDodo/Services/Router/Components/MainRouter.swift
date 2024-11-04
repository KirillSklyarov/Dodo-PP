import UIKit

final class MainRouter {

    // MARK: - Properties
    var storage: DataStorage
    var navigationController: UINavigationController
    var callback: ((UIViewController) -> Void)?

    // MARK: - Init
    init(storage: DataStorage, navigationController: UINavigationController) {
        self.storage = storage
        self.navigationController = navigationController
    }
}

// MARK: - Public methods
extension MainRouter {
    func goToMainVC(router: AppRouter) {
        let vc = MainViewController(storage: storage, router: router)
        navigationController.pushViewController(vc, animated: true)
    }

    func goToStories(callback: ((UIViewController) -> Void)?) {
        let vc = StoriesVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true) {
            callback?(vc)
        }
    }

    func goToProductDetails(router: AppRouter, callback: ((UIViewController) -> Void)?) {
        let vc = ProductDetailsViewController(storage: storage, router: router)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true) { callback?(vc) }
    }

    func showPopUpView(_ popUpView: CpfcPopupView?) {
        guard let popUpView else { print("PopUpView is nil"); return }
        navigationController.visibleViewController?.present(popUpView, animated: true)
    }
}

