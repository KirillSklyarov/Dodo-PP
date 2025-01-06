import Foundation

enum ProfileAction {
    case chatAlertButtonTapped
    case dismissButtonTapped
    case personalDataButtonTapped
    case promoTapped(Promo)
    case addressCellTapped
}

enum ProfileScreenState {
    case initial
    case loading
    case success(User, [Promo])
    case error
}

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
        case .promoTapped: onShowPromoVC?()
        case .addressCellTapped: onAddressCellTapped?()
        }
    }
}

// MARK: - ProfileViewModelProtocol
extension ProfileViewModel {
    func initialize() {
        state = .initial
        state = .loading
        fetchData()
    }

    func promoTapped(_ promo: Promo) {
        storage.setSelectedPromo(promo)
        onShowPromoVC?()
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
//        userData = storage.getUserData()
    }

    func fetchPromoFromStorage() {
        promo = storage.getPromo()
    }

    func setSuccessState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, let userData, let promo else {
                self?.onShowErrorAlert?(); return }
            state = .success(userData, promo)
        }
    }
}
