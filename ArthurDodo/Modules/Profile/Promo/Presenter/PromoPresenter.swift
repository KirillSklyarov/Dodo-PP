import Foundation

protocol PromoViewOutput: AnyObject {
    func viewLoaded()
    func sendAction(_ action: PromoAction)
}

enum PromoAction {
    case applyPromo
}

final class PromoPresenter {

    // MARK: - Properties
    weak var view: PromoViewInput?
    private let storage: PromoStorageProtocol
    private let router: PromoRouterInput

    // MARK: - Init
    init(storage: PromoStorageProtocol, router: PromoRouterInput) {
        self.storage = storage
        self.router = router
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PromoViewOutput
extension PromoPresenter: PromoViewOutput {
    // Как только узнали, что view загрузилась, то выставляем ей базовое состояние и фетчим данные
    func viewLoaded() {
        view?.setInitialState()
        fetchData()
    }

    func sendAction(_ action: PromoAction) {
        switch action {
        case .applyPromo: view?.updateUIWithAppliedPromo()
        }
    }
}

// MARK: - Supporting methods
private extension PromoPresenter {
    // Забираем данные из хранилища и обновляем UI
    func fetchData() {
        guard let offer = storage.getSelectedPromo() else { print("No promo selected"); return }
        view?.configureUI(with: offer)
    }
}

