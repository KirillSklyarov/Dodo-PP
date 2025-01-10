import UIKit

protocol ProfileRouterInput: AnyObject {
    func dismiss()
    func showSupportModule()
    func showPersonalDataModule()
    func showPromoModule()
    func showAddressVC()
    func showProfileErrorAlertModule()

    var onProfileDismissed: (() -> Void)? { get set }
    var navigationController: UINavigationController? { get set }
}

final class ProfileRouter {
    // FIXME: - Временно, потом надо убрать, когда избавлюсь от координатора
    var onProfileDismissed: (() -> Void)?
    weak var navigationController: UINavigationController?

    weak var view: ModuleTransitionable?
    private let moduleFactory: ProfileModuleFactory

    // MARK: - Init
    init(moduleFactory: ProfileModuleFactory) {
        self.moduleFactory = moduleFactory
    }
}

// MARK: - ProfileRouterInput
extension ProfileRouter: ProfileRouterInput {
    func dismiss() {
        onProfileDismissed?()
        view?.dismissModule()
    }

    func showSupportModule() {
        let vc = moduleFactory.makeModule(for: .chatAlert)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        view?.present(vc)
    }

    func showPersonalDataModule() {
        let vc = moduleFactory.makeModule(for: .personalData)
        view?.present(vc)
    }

    func showPromoModule() {
        let vc = moduleFactory.makeModule(for: .promo)
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        view?.present(vc)
    }

    // Показываем экран с адресами
    func showAddressVC() {
        let vc = moduleFactory.makeModule(for: .chooseAddress)
        vc.modalPresentationStyle = .fullScreen
        view?.present(vc)
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showProfileErrorAlertModule() {
        let vc = moduleFactory.makeErrorAlert(for: .profile) { [weak self] in
            self?.dismiss() // Закрываем экран
//          self?.onFlowFinished?() // Говорим что флоу закончен
        }

        view?.present(vc)
    }
}
