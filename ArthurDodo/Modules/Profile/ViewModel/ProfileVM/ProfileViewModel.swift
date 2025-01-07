import Foundation

enum ProfileAction {
    case chatAlertButtonTapped
    case dismissButtonTapped
    case personalDataButtonTapped
    case promoTapped(Promo)
    case addressCellTapped
}

typealias ProfileScreenState = BaseScreenState<(User, [Promo])>

final class ProfileViewModel: ProfileViewModelProtocol {
    // MARK: - Properties
    private var userData: User?
    private var promo: [Promo]?

    private var state: ProfileScreenState? {
        didSet {
            guard let state else { return }
            onStateChanged?(state)
        }
    }

    // MARK: - Callbacks
    var onShowChatAlert: (() -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onShowPersonalData: (() -> Void)?
    var onShowPromoVC: (() -> Void)?
    var onAddressCellTapped: (() -> Void)?
    var onShowErrorAlert: (() -> Void)?

    var onStateChanged: ((ProfileScreenState) -> Void)?

    // MARK: - Other properties
    private let storage: ProfileStorage

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - Event handling
extension ProfileViewModel {
    func sendAction(_ action: ProfileAction) {
        switch action {
        case .chatAlertButtonTapped: onShowChatAlert?()
        case .dismissButtonTapped: onDismissButtonTapped?()
        case .personalDataButtonTapped: onShowPersonalData?()
        case .promoTapped(let promo): promoTapped(promo)
        case .addressCellTapped: onAddressCellTapped?()
        }
    }
}

// MARK: - ProfileViewModelProtocol
extension ProfileViewModel {
    // Устанавливаем первоначальное состояние экрана
    func setInitialState() {
        state = .initial
    }

    // Инитим загрузку данных
    func initialize() {
        state = .loading
        fetchData()
    }
}

// MARK: - Fetch Data
private extension ProfileViewModel {
    // Фетчим данные из хранилища
    func fetchData() {
        fetchUserDataFromStorage()
        fetchPromoFromStorage()
        setSuccessState()
    }

    // Запрашиваем персональные данные с сервера: додокоины, кол-во заказов, адреса
    func fetchUserDataFromStorage() {
        userData = storage.getUserData()
    }

    func fetchPromoFromStorage() {
        promo = storage.getPromo()
    }

    // Если какие-то данные не получили, то показывает алерт с ошибкой, если все ок, то выставляем статус success
    func setSuccessState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, let userData, let promo else {
                self?.onShowErrorAlert?(); return }
            state = .success((userData, promo))
        }
    }
}

// MARK: - Supporting methods
private extension ProfileViewModel {
    func promoTapped(_ promo: Promo) {
        storage.setSelectedPromo(promo)
        onShowPromoVC?()
    }
}
