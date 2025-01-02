import Foundation
import Combine

enum ProfileAction {
    case chatAlertButtonTapped
    case dismissButtonTapped
    case personalDataButtonTapped
    case promoTapped(Promo)
    case addressCellTapped
}

final class ProfileViewModel: ProfileViewModelProtocol {
    // MARK: - Properties
    @Published private var userData: User?
    @Published private var promo: [Promo]?

    var userDataPublisher: Published<User?>.Publisher { $userData }
    var promoPublisher: Published<[Promo]?>.Publisher { $promo }
    var onShowChatAlert: (() -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onShowPersonalData: (() -> Void)?
    var onShowPromoVC: (() -> Void)?
    var onAddressCellTapped: (() -> Void)?

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
        fetchData()
    }

    func promoTapped(_ promo: Promo) {
        storage.setSelectedPromo(promo)
        onShowPromoVC?()
    }
}

// MARK: - Fetch Data
private extension ProfileViewModel {
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

