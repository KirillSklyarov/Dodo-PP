import UIKit
import SafariServices

final class ProfileCoordinator {
    // MARK: - Properties
    private let router: Router
    private let moduleFactory: ProfileModuleFactory

    var onFlowFinished: (() -> Void)?

    // MARK: - Init
    init(moduleFactory: ProfileModuleFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.router = router
    }

    deinit {
        print("ProfileCoordinator deinit")
    }
}

extension ProfileCoordinator: Coordinator {
    // Создаем модуль и обрабатываем события замыкания для координатора (это управление навигацией между другими модулями)
    func start() {
        let viewController = moduleFactory.makeModule(for: .profile)
        guard let viewController = viewController as? ProfileViewController else { print("Can't cast ProfileViewController"); return }
        let presenter = viewController.output

        presenter.coordinatorEventHandler = { [weak self] coordinatorEvent in
            guard let self else { return }
            switch coordinatorEvent {
            case .dismissModule: dismissModule()
            case .showSupportModule: showSupportModule()
            case .showPersonalDataModule: showPersonalDataModule()
            case .showPromoModule: showPromoModule()
            case .showChooseAddressModule: showChooseAddressModule()
            case .showProfileErrorAlertModule: showProfileErrorAlertModule()
            }
        }

        router.present(viewController)
    }
}

// MARK: - Supporting methods
private extension ProfileCoordinator {
    func dismissModule() {
        router.dismiss()
        onFlowFinished?()
    }

    func showSupportModule() {
        let vc = moduleFactory.makeModule(for: .chatAlert)
        vc.modalTransitionStyle = .crossDissolve
        router.present(vc, modalPresentation: .overFullScreen)
    }

    func showPersonalDataModule() {
        let vc = moduleFactory.makeModule(for: .personalData)
        guard let vc = vc as? PersonalViewController else { return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self, weak vc] coordinatorEvent in
            guard let self, let vc else { return }
            switch coordinatorEvent {
            case .dismissModule: router.dismiss()
            case .showLegalInfoModule(let url): showURL(url: url, view: vc)
            case .showPersonalDataErrorAlertModule: showPersonalDataErrorAlertModule()
            }
        }

        router.present(vc)
    }

    func showURL(url: URL, view: UIViewController) {
        let safariVC = SFSafariViewController(url: url)
        view.present(safariVC, animated: true)
    }

    func showPromoModule() {
        let vc = moduleFactory.makeModule(for: .promo)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        router.present(vc)
    }

    // Показываем экран с адресами
    func showChooseAddressModule() {
        guard let vc = moduleFactory.makeModule(for: .chooseAddress) as? ChooseAddressViewController else { return }
        let presenter = vc.output

        presenter.coordinatorEventHandler = { [weak self] coordinatorEvent in
            guard let self else { return }
            switch coordinatorEvent {
            case .dismissModule: router.dismiss()
            case .showAddressErrorAlert: showChooseAddressErrorAlertModule()
            default : break
            }
        }

        router.present(vc, modalPresentation: .fullScreen)
    }
}

// MARK: - Show Error Alerts
private extension ProfileCoordinator {
    // Показываем алёрт с ошибкой и при нажатии на кнопку на алёрте закрываем окно
    func showChooseAddressErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .chooseAddressError) {
            self.dismissModule()
        }
        router.present(vc)
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showProfileErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .profileError) { [weak self] in
            self?.dismissModule()
        }

        router.present(vc)
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showPersonalDataErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .chooseAddressError) { [weak self] in
            self?.dismissModule()
        }

        router.present(vc)
    }
}
