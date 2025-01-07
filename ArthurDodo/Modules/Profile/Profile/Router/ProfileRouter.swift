import Foundation
import SafariServices

protocol ProfileRouterInput: AnyObject {
    func dismiss()
    func showChatAlert()
    func showPersonalData()
    func showPromoVC()
    func showAddressVC()
    func showProfileErrorAlert()

    var onProfileDismissed: (() -> Void)? { get set }
    var navigationController: UINavigationController? { get set }
}

final class ProfileRouter {
    // FIXME: - Временно, потом надо убрать, когда избавлюсь от координатора
    var onProfileDismissed: (() -> Void)?
    weak var navigationController: UINavigationController?

    private let view: ModuleTransitionable
    private let moduleFactory: ProfileModuleFactory

    // MARK: - Init
    init(view: ModuleTransitionable, moduleFactory: ProfileModuleFactory) {
        self.view = view
        self.moduleFactory = moduleFactory
    }
}

// MARK: - ProfileRouterInput
extension ProfileRouter: ProfileRouterInput {
    func dismiss() {
        onProfileDismissed?()
        view.dismissModule()
    }

    func showChatAlert() {
        let vc: AppActionSheet = moduleFactory.makeModule(for: .chatAlert)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen

        vc.onDismissButtonTapped = { [weak self] in
            self?.dismiss()
        }

        view.present(vc, animated: false)
    }

    func showPromoVC() {
        let vc: PromoViewController = moduleFactory.makeModule(for: .promo)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        view.present(vc, animated: true)
    }

    // Показываем экран с адресами
    func showAddressVC() {
        let vc: ChooseAddressVC = moduleFactory.makeModule(for: .delivery)
        let presenter = vc.getViewModel()
        vc.modalPresentationStyle = .automatic

        presenter.onDismissButtonTapped = { [weak self] in
            self?.dismiss()
        }

        view.present(vc, animated: true)
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showProfileErrorAlert() {
        let vc = moduleFactory.makeModule(for: .error) { [weak self] in
            self?.dismiss() // Закрываем экран
            //            self?.onFlowFinished?() // Говорим что флоу закончен
        }

        view.present(vc, animated: true)
    }

    func showPersonalData() {
        let vc: PersonalViewController = moduleFactory.makeModule(for: .personalData)
        let presenter = vc.viewModel

        presenter.onDismissButtonTapped = { [weak self] in
            self?.dismiss()
        }

        presenter.onShowURL = { [weak self] url in
            self?.showURL(url: url)
        }

        presenter.onShowErrorAlert = { [weak self] in
            self?.showPersonalErrorAlert(personalVC: vc)
        }

        view.present(vc, animated: true)
    }

    // Показываем экран с ошибкой
    func showPersonalErrorAlert(personalVC: PersonalViewController) {
        let vc = moduleFactory.makeModule(for: .error) { [weak self] in
            self?.dismiss() // Закрываем экран c родительского экрана
        }

        view.present(vc, animated: true)
    }
}

// MARK: - Supporting methods
private extension ProfileRouter {
    // Показываем экран браузера по ссылке
    func showURL(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { print("Can't open URL"); return }
        let safariVC = SFSafariViewController(url: url)
        view.present(safariVC, animated: true)
    }
}
