import Foundation
import Combine

protocol PersonalViewModelProtocol {
    func fetchData()
    func showURL()

    var personalDataPublisher: Published<User?>.Publisher { get }
    var urlPublisher: Published<URL?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
}

final class PersonalViewModel {

    @Published var personalData: User?
    @Published var url: URL?

    var personalDataPublisher: Published<User?>.Publisher { $personalData }
    var urlPublisher: Published<URL?>.Publisher { $url }

    private let storage: ProfileStorage

    var onDismissButtonTapped: (() -> Void)?

    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - PersonalViewModelProtocol
extension PersonalViewModel: PersonalViewModelProtocol {
    // Забираем данные с сервера и передаем их для отображения
    func fetchData() {
        self.personalData = storage.getUserData()
    }

    func showURL() {
        url = URL(string: "https://www.dodopizza.ru")
    }
}
