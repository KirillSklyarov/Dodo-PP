import SafariServices

protocol PersonalRouterInput: AnyObject {
    func dismiss()
    func showURL(url: URL)
    func showPersonalErrorAlert()
}

final class PersonalRouter {
    weak var view: ModuleTransitionable?
    private let moduleFactory: ProfileModuleFactory

    // MARK: - Init
    init(moduleFactory: ProfileModuleFactory) {
        self.moduleFactory = moduleFactory
    }

    deinit {
        print("PersonalRouter deinit")
    }
}

// MARK: - ProfileRouterInput
extension PersonalRouter: PersonalRouterInput {
    // Закрываем модуль
    func dismiss() {
        view?.dismissModule()
    }

    // Показываем экран браузера по ссылке
    func showURL(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        view?.present(safariVC)
    }

    // Показываем экран с ошибкой
    func showPersonalErrorAlert() {
//        let vc = moduleFactory.makeErrorAlert(for: .personalData) { [weak self] in
//            self?.view?.dismissModule() // Закрываем экран c родительского экрана
//        }
//
//        view?.present(vc)
    }
}
