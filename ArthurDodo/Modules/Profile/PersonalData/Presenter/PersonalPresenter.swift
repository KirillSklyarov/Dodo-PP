import UIKit

enum PersonalDataAction {
    case dismissButtonTapped
    case showURLTapped
}

protocol PersonalViewOutput: AnyObject {
    func viewLoaded()
    func sendAction(_ action: PersonalDataAction)
}

final class PersonalPresenter {

    // MARK: - Properties
    private var personalData: User?

    private let router: PersonalRouterInput
    weak var view: PersonalViewInput?

    private let storage: ProfileStorage

    // MARK: - Init
    init(storage: ProfileStorage, router: PersonalRouterInput) {
        self.storage = storage
        self.router = router
    }

    deinit {
        print("PersonalPresenter deinit")
    }
}

// MARK: - PersonalViewOutput
extension PersonalPresenter: PersonalViewOutput {
    // Устанавливаем первоначальное состояние
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    // Event Handler
    func sendAction(_ action: PersonalDataAction) {
        switch action {
        case .dismissButtonTapped: router.dismiss()
        case .showURLTapped: showURL()
        }
    }
}

// MARK: - Supporting methods
private extension PersonalPresenter {
    // Метод для загрузки данных (сначала показывать лоадинг, фетчим данные, потом обновляем UI c полученными данными)
    func loadData() {
        view?.showLoading()
        fetchData()
        updateUIWith(personalData)
    }

    // Обновляем UI с полученными данными
    private func updateUIWith(_ user: User?) {
        guard let user else { setErrorState(); return }
        view?.configure(with: user)
    }

    // Забираем данные с сервера
    func fetchData() {
        personalData = storage.getUserData()
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        router.showPersonalErrorAlert()
        view?.showError()
    }

    func showURL() {
        guard let url = URL(string: "https://www.dodopizza.ru") else { print("Failed to create URL"); return }
        router.showURL(url: url)
    }
}
