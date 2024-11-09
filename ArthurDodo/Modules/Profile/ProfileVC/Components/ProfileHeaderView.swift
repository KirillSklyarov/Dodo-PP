import UIKit

final class ProfileHeaderView: UIView {

    // MARK: - Properties
    private let viewHeight: CGFloat = 40
    private let rightInset: CGFloat = -10

    // MARK: - Callbacks
    var onDismissButtonTapped: (() -> Void)?
    var onChatButtonTapped: (() -> Void)?
    var onProfileButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView()
    private lazy var chatButton = ProfileButtonView(type: .chat)
    private lazy var profileButton = ProfileButtonView(type: .profile)

    private lazy var rightButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chatButton, profileButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [dismissButton, spacer, rightButtonsStackView])
        stackView.axis = .horizontal
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup actions
private extension ProfileHeaderView {
    func setupActions() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }

        chatButton.onButtonTapped = { [weak self] in
            self?.onChatButtonTapped?()
        }

        profileButton.onButtonTapped = { [weak self] in
            self?.onProfileButtonTapped?()
        }
    }
}

// MARK: - Setup UI
private extension ProfileHeaderView {
    func setupUI() {
        addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        setupContentContainerLayout()
    }

    func setupContentContainerLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
