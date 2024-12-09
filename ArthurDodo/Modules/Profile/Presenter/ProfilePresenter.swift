import Foundation

protocol ProfileViewProtocol: AnyObject {
    func updatePersonalData(_ personalData: User)
    func updatePromo(_ promo: [Promo])
    func setState(view: ProfileView, state: ScreenState)
}

// Презентер профиля
final class ProfilePresenter {

    // MARK: - Properties
    weak var view: ProfileViewProtocol?

    private var state: ScreenState = .loading
    private let storage: ProfileStorage

    var onShowChatAlert: (() -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onShowPersonalData: (() -> Void)?
    var onShowPromoVC: ((Promo) -> Void)?

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }

    deinit {
        print("ProfilePresenter deinit")
    }

    func viewDidLoad() {
        fetchData()
    }
}

// MARK: - Fetch Data
private extension ProfilePresenter { // Запрашиваем данные с сервера
    func fetchData() {
        fetchUserDataFromStorage()
        fetchPromoFromStorage()
        view?.setState(view: .mission, state: .success) // Выставляю нижней вью правильное состояние (потом можно будет убрать)
    }

    // Запрашиваем персональные данные с сервера: додокоины, кол-во заказов, адреса
    func fetchUserDataFromStorage() {
        guard let personalData = storage.getUserData() else { print("Error: fetchUserDataFromStorage"); return }
        view?.updatePersonalData(personalData)
        view?.setState(view: .personalData, state: .success)
    }

    // Запрашиваем спецпредложения с сервера (раздел Акции), передаем данные на вью и выставляем состояние у вьюхи
    func fetchPromoFromStorage() {
        let promo = storage.getPromo()
        view?.updatePromo(promo)
        view?.setState(view: .promo, state: .success)
    }
}
