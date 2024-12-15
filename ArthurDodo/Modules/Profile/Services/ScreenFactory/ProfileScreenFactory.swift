import Foundation

protocol ProfileScreenFactoryProtocol: AnyObject {
    func makeProfileScreen() -> ProfileViewController
    func makePersonalDataScreen() -> PersonalViewController
    func makeChatAlertScreen() -> AppActionSheet
    func makePromoScreen(_ offer: Promo) -> PromoViewController
}

// Класс фабрика экранов отвечает за создание экранов
final class ProfileScreenFactory {
    // MARK: - Properties
    private let storage: ProfileStorage

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - Methods
extension ProfileScreenFactory: ProfileScreenFactoryProtocol {
    func makeProfileScreen() -> ProfileViewController {
        let presenter = ProfilePresenter(storage: storage)
        let view = ProfileViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makePersonalDataScreen() -> PersonalViewController {
        let presenter = PersonalPresenter(storage: storage)
        let view = PersonalViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeChatAlertScreen() -> AppActionSheet {
        return AppActionSheet()
    }

    func makePromoScreen(_ offer: Promo) -> PromoViewController {
        return PromoViewController(with: offer)
    }
}
