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

// MARK: - Present&Dismiss
extension Router {
    // Метод present находит самый верхний контроллер (тот, который мы видим на экране, даже при каскаде модульных экранов) и показывает нам новый экран (vc) именно на верхнем экране
    func present(_ vc: UIViewController, animated: Bool = true, modalPresentation: UIModalPresentationStyle = .automatic) {
        vc.modalPresentationStyle = modalPresentation
        let topVC = findTopVC()
        topVC.present(vc, animated: animated)
    }

    // Метод закрывает экран с активного показанного экрана (не работает с каскадом модальных экранов)
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        let topVC = findTopVC()
        topVC.dismiss(animated: animated, completion: completion)
    }
}

// MARK: - Other public methods
extension Router {
    // Устанавливаем экран как основной у navigationController и он его показывает в этом же методе. С помощью методе setViewControllers убираем действующие VC в навигации и устанавливаем новый VC, при этом navigationController остается тем же, то есть не создается новый экземпляр.
    func setRootModule(_ module: UIViewController, animation: Bool = false) {
        navigationController.setViewControllers([module], animated: animation)
    }

    // Устанавливаем root VC (нужен для SceneDelegate)
    func setRootNavigation() -> UINavigationController {
        navigationController.navigationBar.isHidden = true
        return navigationController
    }

    // Метод при показе present возвращает родительский ViewController - так как он сейчас один и это MainVC, поэтому сразу кастим до него
    func getMainViewController() -> MainViewController? {
        guard let mainVC = navigationController.viewControllers.last as? MainViewController else {  print("Error: MainVC not found"); return nil}
        return mainVC
    }
}

// MARK: - Supporting methods
extension Router {
    // Находит самый верхний контроллер в каскаде модальных экранов
    func findTopVC() -> UIViewController {
        if let parent = navigationController.visibleViewController {
            return findTopMostViewController(from: parent)
        } else { print("Can't find topVC"); return navigationController }
    }

    // Вспомогательный метод, который перебивает все контроллеры и находит последний, у которого нет presentedViewController, а значит он будет самый верхний
    func findTopMostViewController(from vc: UIViewController) -> UIViewController {
        if let presentedVC = vc.presentedViewController {
            return findTopMostViewController(from: presentedVC)
        }
        return vc
    }
}

//    func getNavigationController() -> UINavigationController {
//        navigationController
//    }

    // Метод present, когда сам навигационный контроллер показывает новый экран
//    func present(_ vc: UIViewController, animated: Bool = true, modalPresentation: UIModalPresentationStyle = .automatic) {
//        vc.modalPresentationStyle = modalPresentation
//        navigationController.present(vc, animated: animated)
//    }

    //  Метод present, когда у нас каскад модальных экранов и нам нужен вызывать новый экран именно на последнем экране (в этом случае visibleViewController не будет работать)
//    func present(from parent: UIViewController, vcToShow: UIViewController, animated: Bool = true, modalPresentation: UIModalPresentationStyle = .automatic) {
//        vcToShow.modalPresentationStyle = modalPresentation
//        parent.present(vcToShow, animated: animated)
//    }

    // Метод закрывает экран с указанного экрана: работает с каскадом модальных экранов
//    func dismiss(from parentVC: UIViewController, animated: Bool = true) {
//        parentVC.dismiss(animated: animated)
//    }

    // Метод закрывает экран с navigationController
//    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
//        navigationController.dismiss(animated: animated, completion: completion)
//    }

//}
