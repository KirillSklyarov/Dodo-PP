import UIKit
import SafariServices

final class PersonalPresenter {

    // MARK: - View
    weak var view: PersonalViewProtocol?

    // MARK: - Other Properties
    private let storage: ProfileStorage
    private var personalData: User?

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }

    func viewDidLoad() {
        fetchData()
    }
}

// MARK: - Fetch Data
private extension PersonalPresenter {
    // Забираем данные с сервера и передаем их для отображения
    func fetchData() {
        self.personalData = storage.getUserData()
        updateUserData()
    }
}


extension PersonalPresenter {
    // Передаем данные на view для отображения
    func updateUserData() {
        if let personalData {
            view?.updateUserData(personalData)
        }
    }

    func showURL() {
        guard let url = URL(string: "https://www.dodopizza.ru") else { print("Invalid URL"); return }
        view?.showURL(url: url)
    }
}
