import UIKit

final class AddressCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: AddressScreenFactory

    var onFlowFinished: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: AddressScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("AddressCoordinator deinit")
    }

    func start() {
        let addressVC = screenFactory.makeAddressScreen()
        let presenter = addressVC.presenter

        presenter.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            router.dismiss()
            onFlowFinished?()
        }

        presenter.onShowEditAddressVC = { [weak self] in
            self?.showEditAddressVC()
        }

        presenter.onShowAddNewAddressVC = { [weak self] in
            self?.showAddNewAddressVC()
        }

        // Нажали на кнопку "Доставить сюда"
        presenter.onDeliveryButtonTapped = { [weak self] in
            self?.router.dismiss()
            self?.onFlowFinished?()
        }

        router.present(addressVC, modalPresentation: .fullScreen)
    }
}

// MARK: - Supporting methods
private extension AddressCoordinator {
    func showEditAddressVC() {
        let editAddressVC = screenFactory.makeEditAddressScreen()
        let presenter = editAddressVC.presenter
        router.present(editAddressVC, isParent: true, modalPresentation: .fullScreen)

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        presenter.onSaveButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }

    func showAddNewAddressVC() {
        let vc = screenFactory.makeAddNewAddressScreen()
        let presenter = vc.presenter
        router.present(vc, isParent: true, modalPresentation: .fullScreen)

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        presenter.onSaveNewAddressButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }
}
