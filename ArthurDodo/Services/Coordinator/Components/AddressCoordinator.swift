import UIKit

final class AddressCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory

    var onFlowFinished: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("AddressCoordinator deinit")
    }

    func start() {
        let addressVC = screenFactory.makeAddressScreen()

        addressVC.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            router.dismiss()
            onFlowFinished?()
        }

        addressVC.onShowEditAddressVC = { [weak self] address in
            self?.showEditAddressVC(address)
        }

        addressVC.onShowAddNewAddressVC = { [weak self] in
            self?.showAddNewAddressVC()
        }

        // Нажали на кнопку "Доставить сюда"
        addressVC.onDeliveryButtonTapped = { [weak self] in
            self?.router.dismiss()
            self?.onFlowFinished?()
        }

        router.present(addressVC, modalPresentation: .fullScreen)
    }
}

// MARK: - Supporting methods
private extension AddressCoordinator {
    func showEditAddressVC(_ address: Address) {
        let editAddressVC = screenFactory.makeEditAddressScreen(address)
        router.present(editAddressVC, isParent: true, modalPresentation: .fullScreen)

        editAddressVC.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        editAddressVC.onSaveButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }

    func showAddNewAddressVC() {
        let vc = screenFactory.makeAddNewAddressScreen()
        router.present(vc, isParent: true, modalPresentation: .fullScreen)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        vc.onSaveNewAddressButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }
}
