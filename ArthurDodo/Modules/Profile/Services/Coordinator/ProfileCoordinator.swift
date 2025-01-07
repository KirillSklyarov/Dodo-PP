import UIKit

final class ProfileCoordinator: Coordinator {
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

extension ProfileCoordinator {
    func start() {
        let viewController: ProfileViewController = moduleFactory.makeModule(for: .profile)
        let presenter = viewController.output
        let router = presenter?.router
        router?.navigationController = self.router.getNavigationController() // Это пока временное решение, потом мы вообще уберем координатор

        router?.onProfileDismissed = { [weak self] in
            self?.onFlowFinished?()
        }

        router?.navigationController?.present(viewController, animated: true)
    }
}





        // Отрабатываем замыкания
//        presenter?.onDismissButtonTapped = { [weak self] in
//            self?.router.dismiss() // Закрываем экран
//            self?.onFlowFinished?() // Говорим что флоу закончен
//        }
//        
//        presenter?.onShowChatAlert = { [weak self] in
//            self?.showChatAlert()
//        }
//
//        presenter?.onShowPersonalData = { [weak self] in
//            self?.showPersonalData()
//        }
//
//        presenter?.onShowPromoVC = { [weak self] in
//            self?.showPromo()
//        }
//
//        presenter?.onAddressCellTapped = { [weak self] in
//            self?.showAddressVC()
//        }
//
//        presenter?.onShowErrorAlert = { [weak self] in
//            self?.showProfileErrorAlert()
//        }

//        router.present(profileVC) // Показываем экран
//    }
//}

// MARK: - Supporting methods
//private extension ProfileCoordinator {
//    func showPromo() {
//        let vc: PromoViewController = moduleFactory.makeScreen(for: .promo)
//        guard let configureSheet = vc.sheetPresentationController else { return }
//        configureSheet.detents = [.medium()]
//        configureSheet.prefersGrabberVisible = true
//        router.present(vc, isParent: true)
//    }
//
//    func showChatAlert() {
//        let vc: AppActionSheet = moduleFactory.makeScreen(for: .chatAlert)
//        vc.modalTransitionStyle = .crossDissolve
//        router.present(vc, isParent: true, animated: false, modalPresentation: .overFullScreen)
//
//        vc.onDismissButtonTapped = { [weak self] in
//            self?.router.dismiss(isParent: true)
//        }
//    }
//
//    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
//    func showProfileErrorAlert() {
//        let vc = moduleFactory.makeScreen(for: .error) { [weak self] in
//            self?.router.dismiss() // Закрываем экран
//            self?.onFlowFinished?() // Говорим что флоу закончен
//        }
//
//        router.present(vc, isParent: true)
//    }
//
//    func showPersonalData() {
//        let vc: PersonalViewController = moduleFactory.makeScreen(for: .personalData)
//        let viewModel = vc.viewModel
//        router.present(vc, isParent: true, modalPresentation: .automatic)
//
//        viewModel.onDismissButtonTapped = { [weak self] in
//            self?.router.dismiss(isParent: true)
//        }
//
//        viewModel.onShowURL = { [weak self] url in
//            self?.showURL(personalVC: vc, url: url)
//        }
//
//        viewModel.onShowErrorAlert = { [weak self] in
//            self?.showPersonalErrorAlert(personalVC: vc)
//        }
//    }
//
//    // Показываем экран с ошибкой
//    func showPersonalErrorAlert(personalVC: PersonalViewController) {
//        let vc = screenFactory.makeScreen(for: .error) { [weak self] in
//            self?.router.dismiss(from: personalVC) // Закрываем экран c родительского экрана
//        }
//
//        router.present(from: personalVC, vcToShow: vc)
//    }
//
//    // Показываем экран с адресами
//    func showAddressVC() {
//        let vc: ChooseAddressVC = moduleFactory.makeScreen(for: .delivery)
//        let viewModel = vc.getViewModel()
//        router.present(vc, isParent: true, modalPresentation: .automatic)
//
//        viewModel.onDismissButtonTapped = { [weak self] in
//            self?.router.dismiss(isParent: true)
//        }
//    }
//
//    // Показываем экран браузера по ссылке
//    func showURL(personalVC: PersonalViewController, url: URL) {
//        guard UIApplication.shared.canOpenURL(url) else { print("Can't open URL"); return }
//        let safariVC = SFSafariViewController(url: url)
//        router.present(from: personalVC, vcToShow: safariVC)
//    }
//}
