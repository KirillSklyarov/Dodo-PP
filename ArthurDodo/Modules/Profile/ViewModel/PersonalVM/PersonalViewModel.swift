import Foundation
import Combine

enum PersonalDataAction {
    case dismissButtonTapped
    case showURLTapped
}

final class PersonalViewModel {

    // MARK: - Properties
    @Published private var personalData: User?
    @Published private var url: URL?

    var personalDataPublisher: Published<User?>.Publisher { $personalData }
    var urlPublisher: Published<URL?>.Publisher { $url }

    var onDismissButtonTapped: (() -> Void)?

    private let storage: ProfileStorage

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - PersonalViewModelProtocol
extension PersonalViewModel: PersonalViewModelProtocol {
    // Стартовый метод
    func initialize() {
        fetchData()
    }

    func sendAction(_ action: PersonalDataAction) {
        switch action {
        case .dismissButtonTapped: onDismissButtonTapped?()
        case .showURLTapped: showURL()
        }
    }

    func showURL() {
        url = URL(string: "https://www.dodopizza.ru")
    }
}

// MARK: - Supporting methods
private extension PersonalViewModel {
    // Забираем данные с сервера и передаем их для отображения
    func fetchData() {
        self.personalData = storage.getUserData()
    }
}
