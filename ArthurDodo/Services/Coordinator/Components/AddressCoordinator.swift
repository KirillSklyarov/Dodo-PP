import UIKit

final class AddressCoordinator: Coordinator {
    // MARK: - Properties
    private let storage: DataStorage
    private let router: Router
    private let screenFactory: ScreenFactory
    private var mainVC: UIViewController?

    // MARK: - Init
    init(storage: DataStorage, router: Router, screenFactory: ScreenFactory) {
        self.storage = storage
        self.router = router
        self.screenFactory = screenFactory
    }

    func start(_ parentVC: UIViewController) {
        let addressVC = screenFactory.makeAddressScreen()
        self.mainVC = addressVC
        router.present(vc: addressVC, parentVC: parentVC)

        addressVC.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: addressVC)
        }

        addressVC.onShowEditAddressVC = { [weak self] address in
            self?.showEditAddressVC(address)
        }

        addressVC.onShowAddNewAddressVC = { [weak self] in
            self?.showAddNewAddressVC()
        }
    }

    private func showEditAddressVC(_ address: Address) {
        let editAddressVC = screenFactory.makeEditAddressScreen(address)
        router.present(vc: editAddressVC, parentVC: mainVC)

        editAddressVC.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: editAddressVC)
        }
    }

    private func showAddNewAddressVC() {
        let vc = screenFactory.makeAddNewAddressScreen()
        router.present(vc: vc, parentVC: mainVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }
    }
}

