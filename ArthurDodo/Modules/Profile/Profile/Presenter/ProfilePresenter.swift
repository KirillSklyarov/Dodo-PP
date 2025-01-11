import Foundation

protocol ProfileViewOutput: BaseViewControllerOutput where ActionType == ProfileAction {

    var coordinatorEventHandler: ((ProfileCoordinatorEvent) -> Void)? { get set }
}

// Это перечисление действий от view для presenter
enum ProfileAction {
    case chatAlertButtonTapped
    case dismissButtonTapped
    case personalDataButtonTapped
    case promoTapped(Promo)
    case addressCellTapped
}

// Это перечисление действий для координатора
enum ProfileCoordinatorEvent {
    case dismissModule
    case showSupportModule
    case showPersonalDataModule
    case showPromoModule
    case showChooseAddressModule
    case showProfileErrorAlertModule
}

final class ProfilePresenter {
    // MARK: - Properties
    private var userData: User?
    private var promo: [Promo]?

    // MARK: - Other properties
    private let storage: ProfileStorage
    weak var view: (any ProfileViewInput)?

    var coordinatorEventHandler: ((ProfileCoordinatorEvent) -> Void)?

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - ProfileViewOutput
extension ProfilePresenter: ProfileViewOutput {
    // Когда мы получаем информацию, что view загрузилась мы для него устанавливаем начальное значение
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    // Если какие-то данные не получили, то показывает алерт с ошибкой, если все ок, то выставляем статус success
    func updateViewWithData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            isErrorState() ? setErrorState() : updateUI()
        }
    }

    func sendAction(_ action: ProfileAction) {
        switch action {
        case .chatAlertButtonTapped: coordinatorEventHandler?(.showSupportModule)
        case .dismissButtonTapped: coordinatorEventHandler?(.dismissModule)
        case .personalDataButtonTapped: coordinatorEventHandler?(.showPersonalDataModule)

        case .promoTapped(let promo): promoTapped(promo)
        case .addressCellTapped: coordinatorEventHandler?(.showChooseAddressModule)
        }
    }
}

// MARK: - Fetch Data
private extension ProfilePresenter {
    // Инитим загрузку данных
    func loadData() {
        view?.showLoading()
        fetchData()
        updateViewWithData()
    }

    // Фетчим данные из хранилища
    func fetchData() {
        fetchUserDataFromStorage()
        fetchPromoFromStorage()
    }

    // Запрашиваем персональные данные с сервера: додокоины, кол-во заказов, адреса
    func fetchUserDataFromStorage() {
        userData = storage.getUserData()
    }

    func fetchPromoFromStorage() {
        promo = storage.getPromo()
    }
}

// MARK: - Supporting methods
private extension ProfilePresenter {
    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isErrorState() -> Bool {
        let data: [Any?] = [userData, promo]
        return data.allSatisfy { $0 == nil }
    }

    // Прокидываем данные на view и формируем ее
    func updateUI() {
        guard let userData, let promo else { return }
        let data = (userData, promo)
        view?.configure(with: data)
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        coordinatorEventHandler?(.showProfileErrorAlertModule)
        view?.showError()
    }

    func promoTapped(_ promo: Promo) {
        storage.setSelectedPromo(promo)
        coordinatorEventHandler?(.showPromoModule)
    }
}
