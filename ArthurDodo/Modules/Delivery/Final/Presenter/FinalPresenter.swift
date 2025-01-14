import Foundation

// Протокол FinalPresenter
protocol FinalViewControllerOutput: BaseViewControllerOutput where ActionType == FinalViewModelAction {
    var coordinatorEventHandler: ((FinalViewCoordinatorEvent) -> Void)? { get set }
}

// Enum c действиями юзера
enum FinalViewModelAction {
    case dismissButtonTapped
}

final class FinalPresenter {
    // MARK: - Properties
    private var countDownTimer: Timer?
    private var dismissTimer = 3

    var coordinatorEventHandler: ((FinalViewCoordinatorEvent) -> Void)?

    private let storageService: DataStorageService

    weak var view: (any FinalViewControllerInput)?

    // MARK: - Init
    init(storageService: DataStorageService) {
        self.storageService = storageService
    }
}

// MARK: - FinalViewControllerOutput
extension FinalPresenter: FinalViewControllerOutput {
    // Как получаем сведения, что view загружено, то выставляем ей начальное состояние и запускаем таймер
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        setupTimer()
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : setErrorState()
    }

    func sendAction(_ action: FinalViewModelAction) {
        switch action {
        case .dismissButtonTapped: dismissVC()
        }
    }

    func isDataValid() -> Bool {
        return countDownTimer != nil
    }

    func updateView() {
        view?.configure(with: dismissTimer)
    }

    func setErrorState() {
        view?.showError()
        coordinatorEventHandler?(.showFinalError)
    }
}

// MARK: - Setup timer
private extension FinalPresenter {
    func setupTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    // Уменьшаем таймер и либо закрываем окно, либо обновляем label
    @objc private func timerAction() {
        dismissTimer -= 1
        dismissTimer > 0 ? updateTimer() : dismissVC()
    }

    func updateTimer() {
        view?.updateUI(dismissTimer)
    }
}

// MARK: - Supporting methods
private extension FinalPresenter {
    // Выключаем таймер, обнуляем корзину и закрываем все окна
    func dismissVC() {
        countDownTimer?.invalidate()
        storageService.eraseCart()
        coordinatorEventHandler?(.finishFlow)
    }
}
