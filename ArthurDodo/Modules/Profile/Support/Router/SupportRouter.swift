import Foundation

protocol SupportRouterInput: AnyObject {
    func dismiss()
}

final class SupportRouter: SupportRouterInput {
    weak var view: ModuleTransitionable?

    func dismiss() {
        view?.dismissModule()
    }
}
