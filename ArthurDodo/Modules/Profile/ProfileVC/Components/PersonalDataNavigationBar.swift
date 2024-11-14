import UIKit

final class PersonalDataNavigationBar: UINavigationBar {

    // MARK: - UI Properties
    private lazy var dismissButtonView = DismissButtonView()
    private lazy var chatButtonView = ProfileButtonView(type: .chat)
    private lazy var profileButtonView = ProfileButtonView(type: .profile)

    // MARK: - Callbacks
    var onDismissButtonTapped: (() -> Void)?
    var onChatButtonTapped: (() -> Void)?
    var onProfileButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension PersonalDataNavigationBar {
    func setupUI() {
        let item = UINavigationItem(title: "")
        item.leftBarButtonItem = UIBarButtonItem(customView: dismissButtonView)
        item.rightBarButtonItems = [
            UIBarButtonItem(customView: profileButtonView),
            UIBarButtonItem(customView: chatButtonView)
        ]
        setItems([item], animated: false)
    }
}

// MARK: - Setup Actions
private extension PersonalDataNavigationBar {
    func setupActions() {
        dismissButtonView.onButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }

        chatButtonView.onButtonTapped = { [weak self] in
            self?.onChatButtonTapped?()
        }
        
        profileButtonView.onButtonTapped = { [weak self] in
            self?.onProfileButtonTapped?()
        }
    }
}
