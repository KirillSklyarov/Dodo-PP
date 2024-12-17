import Foundation

protocol FinalPresenterProtocol: AnyObject {
    func viewDidLoad()
    func dismissVC()

    var onFinalVCDismissed: (() -> Void)? { get set }
}

final class FinalPresenter {

    // MARK: - Properties
    private var countDownTimer: Timer?
    private var dismissDelay = 2

    weak var view: FinalViewProtocol?
    private let storageService: DataStorageService

    var onFinalVCDismissed: (() -> Void)?

    // MARK: - Init
    init(storageService: DataStorageService) {
        self.storageService = storageService
    }
}

// MARK: - FinalPresenterProtocol
extension FinalPresenter: FinalPresenterProtocol {
    func viewDidLoad() {
        setupTimer()
    }

    // Выключаем таймер, обнуляем корзину и закрываем все окна
    func dismissVC() {
        countDownTimer?.invalidate()
        storageService.eraseCart()
        onFinalVCDismissed?()
    }
}

// MARK: - Setup timer
private extension FinalPresenter {
    func setupTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    // Уменьшаем таймер и либо закрываем окно, либо обновляем label
    @objc private func timerAction() {
        dismissDelay -= 1

        if dismissDelay <= 0 {
            dismissVC()
        } else {
            updateUI(dismissDelay)
        }
    }
}

// MARK: - Supporting methods
extension FinalPresenter {
    func updateUI(_ seconds: Int) {
        view?.updateUI(seconds)
    }
}
