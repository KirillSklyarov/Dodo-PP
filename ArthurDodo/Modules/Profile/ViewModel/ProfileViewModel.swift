import Foundation
import Combine

protocol ProfileViewModelProtocol: AnyObject {
    var userDataPublisher: Published<User?>.Publisher { get }
    var promoPublisher: Published<[Promo]?>.Publisher { get }

    var onShowChatAlert: (() -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowPersonalData: (() -> Void)?  { get set }
    var onShowPromoVC: ((Promo) -> Void)?  { get set }

    func fetchData()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    // MARK: - Properties
    @Published var userData: User?
    @Published var promo: [Promo]?

    var userDataPublisher: Published<User?>.Publisher { $userData }
    var promoPublisher: Published<[Promo]?>.Publisher { $promo }

    private let storage: ProfileStorage

    var onShowChatAlert: (() -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onShowPersonalData: (() -> Void)?
    var onShowPromoVC: ((Promo) -> Void)?

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - Fetch Data
extension ProfileViewModel {
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
