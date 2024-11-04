import UIKit

final class FinalVC: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView()
    private lazy var contentStack = FinalVCContentStackView(dismissDelay)

    // MARK: - Properties
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
    private var countDownTimer: Timer?
    private var dismissDelay = 5

    private let storage: DataStorage
    private let router: AppRouter

    // MARK: - Init
    init(storage: DataStorage, router: AppRouter) {
        self.storage = storage
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupTimer()
    }
}

// MARK: - Setup UI
private extension FinalVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack)

        setupNavigationBar()
        setupLayout()
    }

    func setupNavigationBar() {
        let dismissButton = UIBarButtonItem(customView: dismissButton)
        navigationItem.leftBarButtonItem = dismissButton
    }

    func setupLayout() {
        setupContentStackLayout()
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Setup Actions
private extension FinalVC {
    func setupActions() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            dismissVC()
        }
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
    // Выключаем таймер и закрываем окно
    func dismissVC() {
        countDownTimer?.invalidate()
        eraseOrderAndDismiss()
    }

    // Очищаем заказы и закрываем все окна
    func eraseOrderAndDismiss() {
        storage.eraseOrder()
        router.dismissAllVC()
    }

    func updateTitle(_ seconds: Int) {
        contentStack.updateTitle(seconds)
    }
}
