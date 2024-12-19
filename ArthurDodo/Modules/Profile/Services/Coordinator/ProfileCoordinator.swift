import UIKit

final class ProfileCoordinator: Coordinator {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: ProfileScreenFactoryProtocol

    var onFlowFinished: (() -> Void)?

    // MARK: - Init
    init(router: Router, screenFactory: ProfileScreenFactoryProtocol) {
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
        let viewModel = profileVC.getViewModel()

        // Отрабатываем замыкания
        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss() // Закрываем экран
            self?.onFlowFinished?() // Говорим что флоу закончен
        }
        
        viewModel.onShowChatAlert = { [weak self] in
            self?.showChatAlert()
        }

        viewModel.onShowPersonalData = { [weak self] in
            self?.showPersonalData()
        }

        viewModel.onShowPromoVC = { [weak self] promo in
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
        var viewModel = vc.getViewModel()
        router.present(vc, isParent: true, modalPresentation: .automatic)

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }
}
