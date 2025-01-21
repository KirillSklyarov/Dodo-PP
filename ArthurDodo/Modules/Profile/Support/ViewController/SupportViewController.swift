import UIKit
import AppUIComponentsSPM

protocol SupportViewInput: AnyObject {
    func setInitialState()
    func hideContentStack()
    func showContentStack()
}

final class SupportViewController: UIViewController, ModuleTransitionable {

    // MARK: - UI Properties
    private lazy var callButtonView = AppActionSheetButtonView(.call)
    private lazy var chatButtonView = AppActionSheetButtonView(.chat)
    private lazy var dismissButtonView = AppActionSheetButtonView(.dismiss)
    private lazy var separatorView = AppView(type: .separator)

    private lazy var contentStack = setupContentStack()

    // MARK: - Other Properties
    private var bottomConstraint: NSLayoutConstraint!

    private let output: SupportViewOutput

    // MARK: - Init
    init(output: SupportViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - SupportViewInput
extension SupportViewController: SupportViewInput {
    // Устанавливаем начальное состояние экрана (настраиваем все UI)
    func setInitialState() {
        setupUI()
        setupAction()
    }

    // Плавно закрываем окно вниз - ставим нижний констреинт на 250, что ниже экрана устройства, тем самым стек уходит за пределы экрана и как бы скрывается
    func hideContentStack() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bottomConstraint.constant = 250
            self?.view.layoutIfNeeded()
        }
    }

    // Плавно показываем окно - это достигается тем, что мы ставим нижний констреинт 0 - то есть нижняя граница стека = нижней границы окна
    func showContentStack() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - Setup Actions
private extension SupportViewController {
    func setupAction() {
        dismissButtonView.onButtonTapped = { [weak self] in
            self?.output.sendAction(.dismiss)
        }

        chatButtonView.onButtonTapped = { [weak self] in
            self?.output.sendAction(.chatButtonTapped)
        }

        callButtonView.onButtonTapped = { [weak self] in
            self?.output.sendAction(.callButtonTapped)
        }

        setupGesture()
    }

    // Настраиваем жест, по которому будет закрываться окно, если нажали не на кнопки
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    // Окно закрывается, если нажали не на кнопки
    @objc private func viewTapped() {
        output.sendAction(.dismiss)
    }
}

// MARK: - Setup UI
private extension SupportViewController {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubviews(contentStack)

        setupDismissButton()
        setupLayout()
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
