import UIKit

final class CustomActionSheet: UIViewController {

    // MARK: - UI Properties
    private lazy var callButton = ActionSheetButton(title: "Позвонить")
    private lazy var chatButton = ActionSheetButton(title: "Написать в чат")
    private lazy var dismissButton = ActionSheetButton(title: "Отменить", roundedCorners: true)
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.buttonGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private lazy var callAndChatStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [callButton, separatorView, chatButton])
        stack.axis = .vertical
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        return stack
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [callAndChatStack, dismissButton])
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillProportionally
        return stack
    }()

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
private extension CustomActionSheet {
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
private extension CustomActionSheet {
    func setupAction() {
        dismissButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            hideContentStack()
            onDismissButtonTapped?()
        }

        chatButton.onButtonTapped = {
            print(#function)
        }

        callButton.onButtonTapped = { 
            print(#function)
        }
    }
}

// MARK: - Setup UI
private extension CustomActionSheet {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubviews(contentStack)

        setupLayout()
        setupGesture()
    }

    func setupLayout() {
        contentStackLayout()
    }

    func contentStackLayout() {
        bottomConstraint = contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 250)
        bottomConstraint.isActive = true

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}

// MARK: - Setup Gesture
private extension CustomActionSheet {
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
