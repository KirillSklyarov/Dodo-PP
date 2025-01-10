import UIKit

// Базовая версия протокола
protocol ModuleTransitionable: UIViewController {
    func showModule(_ module: UIViewController)
    func dismissModule()
    func pop()
    func push(_ module: UIViewController)
    func present(_ module: UIViewController, animated: Bool)
}

// Базовая реализация для UIViewController
extension ModuleTransitionable {
    func showModule(_ module: UIViewController) {
        if let navigationController = navigationController {
            navigationController.pushViewController(module, animated: true)
        } else {
            present(module, animated: true)
        }
    }

    func dismissModule() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    func pop() {
        navigationController?.popViewController(animated: true)
    }

    func push(_ module: UIViewController) {
        navigationController?.pushViewController(module, animated: true)
    }

    func present(_ module: UIViewController, animated: Bool = true) {
        present(module, animated: animated)
    }
}
