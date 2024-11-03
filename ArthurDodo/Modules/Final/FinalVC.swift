import UIKit

final class FinalVC: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView()
    private lazy var contentStack = FinalVCContentStackView(dismissDelay)

    // MARK: - Properties
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
    private let topInset: CGFloat = 20
    private var countDownTimer: Timer?
    private var dismissDelay = 5

    private lazy var router = Router(baseVC: self)
    private let storage = DataStorage.shared

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupTimer()
    }
}

// MARK: - Setup timer
private extension FinalVC {
    func setupTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    // Уменьшаем таймер и либо закрываем окно, либо обновляем label
    @objc private func timerAction() {
        dismissDelay -= 1

        if dismissDelay <= 0 {
            dismissVC()
        } else {
            updateTitle(dismissDelay)
        }
    }
}

// MARK: - Supporting methods
private extension FinalVC {
    // Очищаем заказы и закрываем все окна
    func eraseOrderAndDismiss() {
        storage.eraseOrder()
        router.dismissAllVC()
    }

    // Выключаем таймер и закрываем окно
    func dismissVC() {
        countDownTimer?.invalidate()
        eraseOrderAndDismiss()
    }

    func updateTitle(_ seconds: Int) {
        contentStack.updateTitle(seconds)
    }
}

// MARK: - Setup Actions
private extension FinalVC {
    func setupActions() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            eraseOrderAndDismiss()
        }
    }
}

// MARK: - Setup UI
private extension FinalVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(dismissButton, contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupDismissButtonViewLayout()
        setupContentStackLayout()
    }

    func setupDismissButtonViewLayout() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
        ])
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
