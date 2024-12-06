import UIKit

final class AppActionSheet: UIViewController {

    // MARK: - UI Properties
    private lazy var callButtonView = AppActionSheetButtonView(.call)
    private lazy var chatButtonView = AppActionSheetButtonView(.chat)
    private lazy var dismissButtonView = AppActionSheetButtonView(.dismiss)
    private lazy var separatorView = AppView(type: .separator)

    private lazy var contentStack = setupContentStack()

    // MARK: - Other Properties
    private var bottomConstraint: NSLayoutConstraint!

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showContentStack()
    }
}

// MARK: - Supporting methods
private extension AppActionSheet {
    // Плавно показываем окно - это достигается тем, что мы ставим нижний констреинт 0 - то есть нижняя граница стека = нижней границы окна
    func showContentStack() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.bottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }
    }

    // Плавно закрываем окно вниз - ставим нижний констреинт на 250, что ниже экрана устройства, тем самым стек уходит за пределы экрана и как бы скрывается
    func hideContentStack() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bottomConstraint.constant = 250
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - Setup Actions
private extension AppActionSheet {
    func setupAction() {
        dismissButtonView.onButtonTapped = { [weak self] in
            guard let self else { return }
            hideContentStack()
            onDismissButtonTapped?()
        }

        chatButtonView.onButtonTapped = {
            print(#function)
        }

        callButtonView.onButtonTapped = { 
            print(#function)
        }
    }
}

// MARK: - Setup UI
private extension AppActionSheet {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubviews(contentStack)

        setupDismissButton()
        setupLayout()
        setupGesture()
    }

    func setupDismissButton() {
        dismissButtonView.layer.cornerRadius = 10
        dismissButtonView.layer.masksToBounds = true
    }

    func setupLayout() {
        contentStackLayout()
    }

    func contentStackLayout() {
        bottomConstraint = contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 250)
        bottomConstraint.isActive = true

        contentStack.setLocalConstraints(left: 10, right: 10)
    }

    func setupContentStack() -> UIStackView {
        let callAndChatStack = AppStackView([callButtonView, separatorView, chatButtonView], axis: .vertical, cornerRadius: 10)

        let contentStack = AppStackView([callAndChatStack, dismissButtonView], axis: .vertical, spacing: 5, distribution: .fillProportionally)
        return contentStack
    }
}

// MARK: - Setup Gesture
private extension AppActionSheet {
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    // Окно закрывается, если нажали не на кнопки
    @objc private func viewTapped() {
        hideContentStack()
        onDismissButtonTapped?()
    }
}
