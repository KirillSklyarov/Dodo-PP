import UIKit

// Enum с перечислением действий юзера
enum PersonalDataAction {
    case dismissButtonTapped
    case showURLTapped
}

// Enum с действиями координатора
enum PersonalDataCoordinatorEvent: Equatable {
    case dismissModule
    case showLegalInfoModule(URL)
    case showPersonalDataErrorAlertModule
}

protocol PersonalViewOutput: BaseViewControllerOutput where ActionType == PersonalDataAction, CoordinatorEvent == PersonalDataCoordinatorEvent, ViewInputProtocol == any PersonalViewInput {
}


final class PersonalPresenter {

    // MARK: - Properties
    private var personalData: User?

    var coordinatorEventHandler: ((PersonalDataCoordinatorEvent) -> Void)?

    weak var view: (any PersonalViewInput)?
    private let storage: ProfileStorageProtocol

    // MARK: - Init
    init(storage: ProfileStorageProtocol) {
        self.storage = storage
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
        checkDataAndUpdateView()
    }

    // Метод для загрузки данных (сначала показывать лоадинг, фетчим данные, потом обновляем UI c полученными данными)
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

    // Event Handler
    func sendAction(_ action: PersonalDataAction) {
        switch action {
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .showURLTapped: showURL()
        }
    }
}

// MARK: - Supporting methods
private extension PersonalPresenter {
    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isDataValid() -> Bool {
        let data: [Any?] = [personalData]
        return data.allSatisfy { $0 != nil }
    }

    // Обновляем UI с полученными данными
    func updateView() {
        guard let personalData else { return }
        view?.configure(with: personalData)
    }

    // Забираем данные с сервера
    func fetchData() {
        personalData = storage.getUserData()
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        coordinatorEventHandler?(.showPersonalDataErrorAlertModule)
        view?.showError()
    }

    func showURL() {
        guard let url = URL(string: "https://www.dodopizza.ru") else { print("Failed to create URL"); return }
        coordinatorEventHandler?(.showLegalInfoModule(url))
    }
}
