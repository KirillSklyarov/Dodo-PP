import UIKit

//  Роутер отвечает за навигацию в приложении. Мы сразу в ините передаем его навигационный контроллер. C помощью замыканий (completion) мы отрабатываем обратные действия, которые вызываются уже на самом главном экране (это может быть MainVC или CartVC). Мы используем visibleViewController так как иногда встречаются вложенные модальные экраны и они без visibleViewController работать не будут.
final class Router {
    // MARK: - Properties
    private let navigationController: UINavigationController

    // MARK: - Init
    init() {
        self.navigationController = UINavigationController()
    }
}

// MARK: - Present
extension Router {
    // Метод present навигации.
    // На вход приходят:
    //              vc - какой экран нужно показать,
    //              parentVC - булевый, если false - то показ с navigationController, если true то показ с актуального экрана)
    //              modalPresentation - показывать ли на весь экран
    //              animated - понятно, с анимацией или сразу показать
    func present(_ vc: UIViewController,
                 parentVC: Bool = false,
                 modalPresentation: UIModalPresentationStyle = .fullScreen,
                 animated: Bool = true) {
        vc.modalPresentationStyle = modalPresentation
        switch parentVC {
        case true: presentWithParent(vc, animated: animated)
        case false: presentFromNavigation(vc, animated: animated)
        }
    }

    // Метод present, когда у нам необходим родитель, от которого будет исходить показ нового экрана
    func presentWithParent(_ vc: UIViewController, animated: Bool = true) {
        guard let parent = navigationController.visibleViewController else { return }
        parent.present(vc, animated: animated)
    }

    // Метод present, когда сам навигационный контроллер показывает новый экран
    private func presentFromNavigation(_ vc: UIViewController, animated: Bool) {
        navigationController.present(vc, animated: animated)
    }

    // Настройка анимации
    private func setAnimation(_ isSet: Bool) {
        if isSet {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .moveIn
            transition.subtype = .fromTop
            navigationController.view.layer.add(transition, forKey: "transition")
        }
    }
}

// MARK: - Dismiss
extension Router {
    // Есть основной метод Dismiss, который в зависимости от признака isParent либо будет вызывать dismiss от navigationController (при значении false), либо будет вызывать dismiss от родительского экрана (при значении true). Это нужно когда у нас идет каскад модельных экранов и тк они не ложатся в navigationController, то при использовании navigationController он будет разом закрывать все эти экраны, что не всегда удобно.
    func dismiss(isParent: Bool = false) {
        switch isParent {
        case false: dismiss()
        case true: dismissWithParent()
        }
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }

    func dismissWithParent() {
        guard let parent = navigationController.visibleViewController else { return }
        parent.dismiss(animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }

    func setRootNavigation() -> UINavigationController {
        navigationController
    }

    // Устанавливаем экран как основной у navigationController и он его показывает в этом же методе. С помощью методе setViewControllers убираем действующие VC в навигации и устанавливаем новый VC, при этом navigationController остается тем же, то есть не создается новый экземпляр.
    func setRootModule(_ module: UIViewController, animation: Bool = false) {
        setAnimation(animation)
        navigationController.setViewControllers([module], animated: false)
        navigationController.isNavigationBarHidden = true
    }

    func push(_ module: UIViewController, animation: Bool = true) {
        setAnimation(animation)
        navigationController.pushViewController(module, animated: false)
    }

    func getTopViewController() -> UIViewController? {
        navigationController.visibleViewController
    }
}


//private func presentFromParent(_ vc: UIViewController, parent: UIViewController, animated: Bool) {
//    parent.present(vc, animated: animated)
//}
