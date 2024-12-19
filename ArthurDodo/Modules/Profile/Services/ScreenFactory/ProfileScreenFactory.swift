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
        let viewModel = ProfileViewModel(storage: storage)
        let view = ProfileViewController(viewModel: viewModel)
        return view
    }

    func makePersonalDataScreen() -> PersonalViewController {
        let viewModel = PersonalViewModel(storage: storage)
        let view = PersonalViewController(viewModel: viewModel)
        return view
    }

    func makeChatAlertScreen() -> AppActionSheet {
        return AppActionSheet()
    }

    func makePromoScreen(_ offer: Promo) -> PromoViewController {
        return PromoViewController(with: offer)
    }
}
