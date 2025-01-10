import Foundation

protocol SupportViewOutput: AnyObject {
    func viewLoaded()
    func sendAction(_ action: SupportAction)
}

enum SupportAction {
    case dismiss
    case chatButtonTapped
    case callButtonTapped
}

final class SupportPresenter {
    // MARK: - Properties
    weak var view: SupportViewInput?
    private let router: SupportRouterInput

    // MARK: - Init
    init(router: SupportRouterInput) {
        self.router = router
    }
}

extension SupportPresenter: SupportViewOutput {
    // Делаем первоначальную загрузку экрана и показываем анимацию на кнопки
    func viewLoaded() {
        view?.setInitialState()
        showContentStack()
    }

    // Event handler
    func sendAction(_ action: SupportAction) {
        switch action {
        case .dismiss: hideContentStackAndDismiss()
        case .chatButtonTapped: print(#function)
        case .callButtonTapped: print(#function)
        }
    }
}
// MARK: - Supporting methods
private extension SupportPresenter {
    // Показываем анимацию выезжающих кнопок
    func showContentStack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.view?.showContentStack()
        }
    }

    // Показываем анимацию уезжающих кнопок и закрываем окно
    func hideContentStackAndDismiss() {
        view?.hideContentStack()
        router.dismiss()
    }
}
