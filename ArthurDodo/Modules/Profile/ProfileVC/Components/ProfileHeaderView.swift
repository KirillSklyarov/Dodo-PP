import UIKit

final class ProfileHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView()
    private lazy var chatButton = AppButtons(type: .profileChat)
    private lazy var profileButton = AppButtons(type: .personal)

    private lazy var rightButtonsStackView = AppStackView([chatButton, profileButton], axis: .horizontal, spacing: 10, distribution: .fillEqually)

    private lazy var contentStackView = AppStackView([dismissButton, UIView(), rightButtonsStackView], axis: .horizontal)

    // MARK: - Properties
    private let viewHeight: CGFloat = 40

    var onDismissButtonTapped: (() -> Void)?
    var onChatButtonTapped: (() -> Void)?
    var onProfileButtonTapped: (() -> Void)?

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
        dismissButton.onButtonTapped = { [weak self] in
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
        contentStackView.setConstraints()
    }
}
