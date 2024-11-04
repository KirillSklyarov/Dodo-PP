import UIKit

final class AddressRouter {

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
extension AddressRouter {
    func goToAddressVC(router: AppRouter) {
        let vc = AddressViewController(storage: storage, router: router)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }

    func goToEditAddressVC(callback: ((UIViewController) -> Void)?) {
        let vc = EditAddressViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(vc, animated: true) {
            callback?(vc)
        }
    }

    func goToAddNewAddress(callback: ((UIViewController) -> Void)?) {
        let vc = AddNewAddressViewController()
        navigationController.visibleViewController?.present(vc, animated: true) {
            callback?(vc)
        }
    }
}
