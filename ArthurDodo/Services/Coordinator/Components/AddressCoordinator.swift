import UIKit

final class AddressCoordinator: Coordinator {

    // MARK: - Properties
    var storage: DataStorage
    var navigationController: UINavigationController
    var callback: ((UIViewController) -> Void)?
    var parentCoordinator: MainCoordinator?

    // MARK: - Init
    init(storage: DataStorage, navigationController: UINavigationController) {
        self.storage = storage
        self.navigationController = navigationController
    }
}

// MARK: - Public methods
extension AddressCoordinator {
    func start() {
//        let vc = AddressViewController(storage: storage)
//        vc.coordinator = self
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.present(vc, animated: true)
    }

    func showEditAddressVC(_ address: Address) {
//        let vc = EditAddressViewController()
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.visibleViewController?.present(vc, animated: true)
//        vc.getAddressToEdit(address)
    }

    func goToAddNewAddress(callback: ((UIViewController) -> Void)?) {
//        let vc = AddNewAddressViewController(router: ro)
//        navigationController.visibleViewController?.present(vc, animated: true) {
//            callback?(vc)
//        }
    }
}
