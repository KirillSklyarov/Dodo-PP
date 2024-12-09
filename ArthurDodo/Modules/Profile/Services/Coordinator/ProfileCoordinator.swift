import UIKit

final class ProfileCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: ProfileScreenFactory

    var onFlowFinished: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: ProfileScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    deinit {
        print("ProfileCoordinator deinit")
    }
}

extension ProfileCoordinator {
    func start() {
        let profileVC = screenFactory.makeProfileScreen()
        let presenter = profileVC.presenter

        // Отрабатываем замыкания
        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss() // Закрываем экран
            self?.onFlowFinished?() // Говорим что флоу закончен
        }
        
        presenter.onShowChatAlert = { [weak self] in
            self?.showChatAlert()
        }

        presenter.onShowPersonalData = { [weak self] in
            self?.showPersonalData()
        }

        presenter.onShowPromoVC = { [weak self] promo in
            self?.showPromo(promo)
        }

        router.present(profileVC) // Показываем экран
    }
}

// MARK: - Supporting methods
private extension ProfileCoordinator {
    func showPromo(_ offer: Promo) {
        let vc = screenFactory.makePromoScreen(offer)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        router.present(vc, isParent: true)
    }

    func showChatAlert() {
        let vc = screenFactory.makeChatAlertScreen()
        vc.modalTransitionStyle = .crossDissolve
        router.present(vc, isParent: true, animated: false, modalPresentation: .overFullScreen)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }

    func showPersonalData() {
        let vc = screenFactory.makePersonalDataScreen()
        let presenter = vc.presenter
        router.present(vc, isParent: true, modalPresentation: .automatic)

        presenter.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }
}
