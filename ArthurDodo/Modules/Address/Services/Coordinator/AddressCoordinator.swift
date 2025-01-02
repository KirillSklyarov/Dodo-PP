import UIKit

final class AddressCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: AddressScreenFactoryProtocol

    var onFlowFinished: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: AddressScreenFactoryProtocol) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("AddressCoordinator deinit")
    }

    func start() {
        let addressVC = screenFactory.makeAddressScreen()
        let viewModel = addressVC.getViewModel()

        viewModel.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            router.dismiss()
            onFlowFinished?()
        }

        viewModel.onShowEditAddressVC = { [weak self] in
            self?.showEditAddressVC()
        }

        viewModel.onShowAddNewAddressVC = { [weak self] in
            self?.showAddNewAddressVC()
        }

        // Нажали на кнопку "Доставить сюда"
        viewModel.onDeliveryButtonTapped = { [weak self] in
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
        let viewModel = editAddressVC.getViewModel()
        router.present(editAddressVC, isParent: true, modalPresentation: .fullScreen)

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        viewModel.onSaveButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }

    func showAddNewAddressVC() {
        let vc = screenFactory.makeAddNewAddressScreen()
        let viewModel = vc.getViewModel()
        router.present(vc, isParent: true, modalPresentation: .fullScreen)

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }

        viewModel.onSaveNewAddressButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }
}
