import UIKit

final class AddressCoordinator {
    // MARK: - Properties
    private let router: Router
    private let moduleFactory: any AddressModuleFactoryProtocol

    var onFlowFinished: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: any AddressModuleFactoryProtocol) {
        self.router = router
        self.moduleFactory = screenFactory
    }

    deinit {
        print("AddressCoordinator deinit")
    }
}

// MARK: - Coordinator
extension AddressCoordinator: Coordinator {
    func start() {
        // Создаем модуль
        guard let addressVC = moduleFactory.makeModule(for: .address) as? AddressViewController else { return }
        let presenter = addressVC.output

        // Делаем Event Handler для координатора (отрабатываем переходы)
        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule: dismissModule()
            case .showEditAddressVC: showEditAddressVC()
            case .showAddNewAddressVC: showAddNewAddressVC()
            case .deliveryButtonTapped: dismissModule()
            }
        }

        // Показываем экран
        router.present(addressVC, modalPresentation: .fullScreen)
    }
}

// MARK: - Supporting methods
private extension AddressCoordinator {
    // Закрываем экран и finish flow
    func dismissModule() {
        router.dismiss()
        onFlowFinished?()
    }
}

// MARK: - Creating modules
private extension AddressCoordinator {
    func showEditAddressVC() {
        guard let editAddressVC = moduleFactory.makeModule(for: .editAddress) as? EditAddressViewController else { return }
        let presenter = editAddressVC.output

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule, .addressSaved: router.dismiss()
            case .showError: showEditAddressError()
            }
        }

        router.present(editAddressVC, modalPresentation: .fullScreen)
    }

    func showAddNewAddressVC() {
        guard let vc = moduleFactory.makeModule(for: .addNewAddress) as? AddNewAddressViewController else { return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .dismissModule, .addedNewAddress: router.dismiss()
            case .addNewAddressError: showAddNewAddressError()
            }
        }

        router.present(vc, modalPresentation: .fullScreen)
    }
}

// MARK: - Creating error alerts
private extension AddressCoordinator {
    func showEditAddressError() {
        let vc = moduleFactory.makeErrorAlert(for: .addressToEdit) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
    }

    func showAddNewAddressError() {
        let vc = moduleFactory.makeErrorAlert(for: .addNewAddress) { [weak self] in
            self?.router.dismiss()
        }
        router.present(vc)
    }
}
