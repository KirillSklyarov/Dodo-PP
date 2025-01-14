import Foundation

protocol ChooseAddressRouterInput {
    func dismiss()
    func showAddressErrorAlert()
}


final class ChooseAddressRouter {
    weak var view: ModuleTransitionable?

    private let moduleFactory: ProfileModuleFactory

    // MARK: - Init
    init(moduleFactory: ProfileModuleFactory) {
        self.moduleFactory = moduleFactory
    }
}

// MARK: - ChooseAddressRouterInput
extension ChooseAddressRouter: ChooseAddressRouterInput {
    func dismiss() {
        view?.dismissModule()
    }

    // Показываем экран с ошибкой, через комплишн вызываем закрытие окна и флоу, при нажатии на кнопку на алерте
    func showAddressErrorAlert() {
        let vc = moduleFactory.makeErrorAlert(for: .chooseAddressError) { [weak self] in
            self?.dismiss() // Закрываем экран
        }

        view?.present(vc)
    }
}
