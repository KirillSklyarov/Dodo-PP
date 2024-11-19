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

// MARK: - Navigation methods - Version 2
extension Router {
    // Метод present навигации.
    // На вход приходят:
    //              vc - какой экран нужно показать,
    //              parentVC - с какого экрана идет показ (опционально, потому что может быть показ через навигационный контроллер)
    //              modalPresentation - показывать ли на весь экран
    //              animated - понятно, с анимацией или сразу показать
    func present(_ vc: UIViewController,
                 parentVC: UIViewController? = nil,
                 modalPresentation: UIModalPresentationStyle = .fullScreen,
                 animated: Bool = true) {
        vc.modalPresentationStyle = modalPresentation
        if let parentVC {
            present(parent: parentVC, vc: vc, animated: animated)
        } else {
            present(vc: vc, animated: animated)
        }
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
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
}

private extension Router {
    // Метод present, когда у нам необходим родитель, от которого будет исходить показ нового экрана
    func present(parent: UIViewController, vc: UIViewController, animated: Bool) {
        parent.present(vc, animated: animated)
    }

    // Метод present, когда сам навигационный контроллер показывает новый экран
    func present(vc: UIViewController, animated: Bool) {
        navigationController.present(vc, animated: animated)
    }

    func setAnimation(_ isSet: Bool) {
        if isSet {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .moveIn
            transition.subtype = .fromTop
            navigationController.view.layer.add(transition, forKey: "transition")
        }
    }
}
