import Foundation

enum ProfileAction {
    case chatAlertButtonTapped
    case dismissButtonTapped
    case personalDataButtonTapped
    case promoTapped(Promo)
    case addressCellTapped
}

protocol ProfileViewOutput: AnyObject {
    func viewLoaded()
    func sendAction(_ action: ProfileAction)

    var router: ProfileRouterInput { get }
}

final class ProfilePresenter {
    // MARK: - Properties
    private var userData: User?
    private var promo: [Promo]?

    // MARK: - Other properties
    private let storage: ProfileStorage
    private(set) var router: ProfileRouterInput
    private let view: ProfileViewInput

    // MARK: - Init
    init(storage: ProfileStorage, router: ProfileRouterInput, view: ProfileViewInput) {
        self.storage = storage
        self.router = router
        self.view = view
    }
}

// MARK: - ProfileViewOutput
extension ProfilePresenter: ProfileViewOutput {
    // Когда мы получаем информацию, что view загрузилась мы для него устанавливаем начальное значение
    func viewLoaded() {
        view.setupInitialState()
        loadData()
    }

    func sendAction(_ action: ProfileAction) {
        switch action {
        case .chatAlertButtonTapped: router.showChatAlert()
        case .dismissButtonTapped: router.dismiss()
        case .personalDataButtonTapped: router.showPersonalData()
        case .promoTapped(let promo): promoTapped(promo)
        case .addressCellTapped: router.showAddressVC()
        }
    }
}

// MARK: - Supporting methods
private extension ProfilePresenter {
    // Инитим загрузку данных
    func loadData() {
        view.showLoading()
        fetchData()
        updateViewWithData()
    }

    // Если какие-то данные не получили, то показывает алерт с ошибкой, если все ок, то выставляем статус success
    func updateViewWithData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, let userData, let promo else {
                self?.setErrorState(); return }
            view.configure(with: userData, promo)
        }
    }
}

// MARK: - Fetch Data
private extension ProfilePresenter {
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
    func promoTapped(_ promo: Promo) {
        storage.setSelectedPromo(promo)
        router.showPromoVC()
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        router.showProfileErrorAlert()
        view.showError()
    }
}
