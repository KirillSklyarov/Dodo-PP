import Foundation

protocol PersonalViewModelProtocol: BaseViewModelProtocol where ActionType == PersonalDataAction {

    func setInitialState()

    var onScreenStateChanged: ((PersonalDataScreenState) -> Void)? { get set }
    var onShowURL: ((URL) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowErrorAlert: (() -> Void)? { get set }
}

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
    var onShowErrorAlert: (() -> Void)?

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
    // Забираем данные с сервера
    func fetchData() {
        personalData = storage.getUserData()
    }

    // Выставляем состояние экрана (либо успешно, либо ошибка)
    func setSuccessState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, let personalData else {
                self?.onShowErrorAlert?()
                self?.state = .error;
                return
            }
            state = .success(personalData)
        }
    }
}
