import Foundation

enum PersonalDataAction {
    case dismissButtonTapped
    case showURLTapped
}

typealias PersonalDataScreenState = BaseScreenState<User>

final class PersonalViewModel {

    // MARK: - Properties
    private var personalData: User?

    private var state: PersonalDataScreenState? {
        didSet {
            guard let state else { return }
            onScreenStateChanged?(state)
        }
    }

    // MARK: - Callbacks
    var onShowURL: ((URL) -> Void)?
    var onScreenStateChanged: ((PersonalDataScreenState) -> Void)?
    var onDismissButtonTapped: (() -> Void)?

    private let storage: ProfileStorage

    // MARK: - Init
    init(storage: ProfileStorage) {
        self.storage = storage
    }
}

// MARK: - PersonalViewModelProtocol
extension PersonalViewModel: PersonalViewModelProtocol {
    // Устанавливаем первоначальное состояние
    func setInitialState() {
        state = .initial
    }

    // Стартовый метод
    func initialize() {
        state = .loading
        fetchData()
        setSuccessState()
    }

    func sendAction(_ action: PersonalDataAction) {
        switch action {
        case .dismissButtonTapped: onDismissButtonTapped?()
        case .showURLTapped: showURL()
        }
    }

    func showURL() {
        guard let url = URL(string: "https://www.dodopizza.ru") else { return }
        onShowURL?(url)
    }
}

// MARK: - Supporting methods
private extension PersonalViewModel {
    // Забираем данные с сервера и передаем их для отображения
    func fetchData() {
        personalData = storage.getUserData()
    }

    func setSuccessState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, let personalData else { self?.state = .error; return }
            state = .success(personalData)
        }
    }
}
