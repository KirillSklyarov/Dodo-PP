import Foundation

//protocol PromoViewOutput: AnyObject {
//    func viewLoaded()
//    func sendAction(_ action: PromoAction)
//}

enum PromoAction {
    case applyPromo
}

enum PromoCoordinatorEvent {
    case showError
}

protocol PromoViewOutput: BaseViewControllerOutput where ActionType == PromoAction, CoordinatorEvent == PromoCoordinatorEvent, ViewInputProtocol == any PromoViewInput {

}


final class PromoPresenter {

    // MARK: - Properties
    var promo: Promo?
    var coordinatorEventHandler: ((PromoCoordinatorEvent) -> Void)?

    weak var view: (any PromoViewInput)?
    private let storage: PromoStorageProtocol

    // MARK: - Init
    init(storage: PromoStorageProtocol) {
        self.storage = storage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PromoViewOutput
extension PromoPresenter: PromoViewOutput {
    // Как только узнали, что view загрузилась, то выставляем ей базовое состояние и фетчим данные
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        view?.showLoading()
        fetchData()
    }
    
    func checkDataAndUpdateView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            isDataValid() ? updateView() : setErrorState()
        }
    }

    func sendAction(_ action: PromoAction) {
        switch action {
        case .applyPromo: view?.updateUIWithAppliedPromo()
        }
    }
}

// MARK: - Supporting methods
private extension PromoPresenter {
    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isDataValid() -> Bool {
        let data: [Any?] = [promo]
        return data.allSatisfy { $0 != nil }
    }

    // Обновляем вью
    func updateView() {
        guard let promo else { return }
        view?.configure(with: promo)
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        coordinatorEventHandler?(.showError)
        view?.showError()
    }

    // Забираем данные из хранилища и обновляем UI
    func fetchData() {
        promo = storage.getSelectedPromo()
    }
}
