import Foundation
import Combine


final class ProfileViewModel: ProfileViewModelProtocol {
    // MARK: - Properties
    @Published private var userData: User?
    @Published private var promo: [Promo]?

    var userDataPublisher: Published<User?>.Publisher { $userData }
    var promoPublisher: Published<[Promo]?>.Publisher { $promo }
    var onShowChatAlert: (() -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onShowPersonalData: (() -> Void)?
    var onShowPromoVC: ((Promo) -> Void)?

    private let storage: ProfileStorage
    
    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - ProfileViewModelProtocol
extension ProfileViewModel {
    func initialize() {
        fetchData()
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

