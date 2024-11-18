import UIKit

final class ProfileCoordinator: Coordinator {
    // MARK: - Properties
    private let storage: DataStorage
    private let router: Router
    private let screenFactory: ScreenFactory
    private var mainVC: ProfileViewController?

    // MARK: - Init
    init(storage: DataStorage, router: Router, screenFactory: ScreenFactory) {
        self.storage = storage
        self.router = router
        self.screenFactory = screenFactory
    }

    func start(_ parentVC: UIViewController) {
        let profileVC = screenFactory.makeProfileScreen()
        self.mainVC = profileVC
        router.present(vc: profileVC, parentVC: parentVC, modalPresentation: .automatic)

        profileVC.onShowChatAlert = { [weak self] in
            self?.showChatAlert()
        }

        profileVC.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: profileVC)
        }

        profileVC.onShowPersonalData = { [weak self] in
            self?.showPersonalData()
        }

        profileVC.onShowPromoVC = { [weak self] promo in
            self?.showApplySpecialOffer(promo)
        }
    }

    private func showApplySpecialOffer(_ offer: Promo) {
        let vc = screenFactory.makeApplySpecialOfferScreen(offer)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        router.present(vc: vc, parentVC: mainVC, modalPresentation: .automatic)
    }

    private func showPersonalData() {
        let vc = screenFactory.makePersonalDataScreen()
        router.present(vc: vc, parentVC: mainVC)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }
    }

    private func showChatAlert() {
        let vc = screenFactory.makeChatAlertScreen()
        vc.modalTransitionStyle = .crossDissolve
        router.present(vc: vc, parentVC: mainVC, modalPresentation: .overFullScreen, animated: false)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }
    }
}
