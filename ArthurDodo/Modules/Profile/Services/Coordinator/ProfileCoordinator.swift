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
        let profileVC: ProfileViewController = screenFactory.makeScreen(for: .profile)
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

        viewModel.onShowPromoVC = { [weak self] in
            self?.showPromo()
        }

        viewModel.onAddressCellTapped = { [weak self] in
            self?.showAddressVC()
        }

        viewModel.onShowErrorAlert = { [weak self] in
            self?.showProfileErrorAlert()
        }

        router.present(profileVC) // Показываем экран
    }
}

// MARK: - Supporting methods
private extension ProfileCoordinator {
    func showPromo() {
        let vc: PromoViewController = screenFactory.makeScreen(for: .promo)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        router.present(vc, isParent: true)
    }

    func showChatAlert() {
        let vc: AppActionSheet = screenFactory.makeScreen(for: .chatAlert)
        vc.modalTransitionStyle = .crossDissolve
        router.present(vc, isParent: true, animated: false, modalPresentation: .overFullScreen)

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showProfileErrorAlert() {
        let vc = screenFactory.makeScreen(for: .error) { [weak self] in
            self?.router.dismiss() // Закрываем экран
            self?.onFlowFinished?() // Говорим что флоу закончен
        }

        router.present(vc, isParent: true)
    }

    func showPersonalData() {
        let vc: PersonalViewController = screenFactory.makeScreen(for: .personalData)
        let viewModel = vc.getViewModel()
        router.present(vc, isParent: true, modalPresentation: .automatic)

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }

    // Показываем экран с адресами
    func showAddressVC() {
        let vc: ChooseAddressVC = screenFactory.makeScreen(for: .delivery)
        let viewModel = vc.getViewModel()
        router.present(vc, isParent: true, modalPresentation: .automatic)

        viewModel.onDismissButtonTapped = { [weak self] in
            self?.router.dismiss(isParent: true)
        }
    }
}
