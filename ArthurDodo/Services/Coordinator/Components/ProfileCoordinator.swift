import UIKit

final class ProfileCoordinator: Coordinator {
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
        print("ProfileCoordinator deinit")
    }

    func start() {
        let profileVC = screenFactory.makeProfileScreen()
        router.present(profileVC, isParentVC: true, modalPresentation: .automatic)

        profileVC.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss()
            self?.onFlowFinished?()
        }
        
        profileVC.onShowChatAlert = { [weak self] in
            self?.showChatAlert()
        }

        profileVC.onShowPersonalData = { [weak self] in
            self?.showPersonalData()
        }

        profileVC.onShowPromoVC = { [weak self] promo in
            self?.showApplySpecialOffer(promo)
        }
    }
}

// MARK: - Supporting methods
private extension ProfileCoordinator {
    func showApplySpecialOffer(_ offer: Promo) {
        let vc = screenFactory.makeApplySpecialOfferScreen(offer)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        router.present(vc, modalPresentation: .automatic)
    }

    func showChatAlert() {
        let vc = screenFactory.makeChatAlertScreen()
        vc.modalTransitionStyle = .crossDissolve
        router.present(vc, isParentVC: true, modalPresentation: .overFullScreen, animated: false)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }

    func showPersonalData() {
        let vc = screenFactory.makePersonalDataScreen()
        router.present(vc, isParentVC: true, modalPresentation: .automatic)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }
}
