import Foundation
import Combine

final class FinalViewModel {
    // MARK: - Properties
    private var countDownTimer: Timer?

    @Published private var dismissTimer = 2

    var timerPublisher: Published<Int>.Publisher { $dismissTimer }

    var onFinalVCDismissed: (() -> Void)?

    private let storageService: DataStorageService

    // MARK: - Init
    init(storageService: DataStorageService) {
        self.storageService = storageService
    }
}

// MARK: - FinalPresenterProtocol
extension FinalViewModel: FinalViewModelProtocol {
    func initialize() {
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
private extension FinalViewModel {
    func setupTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    // Уменьшаем таймер и либо закрываем окно, либо обновляем label
    @objc private func timerAction() {
        dismissTimer -= 1

        if dismissTimer <= 0 { dismissVC() }

    }
}
