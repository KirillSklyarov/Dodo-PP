import UIKit
import AppUIComponentsSPM

// Это кнопка профиля на главном экране с додокоинами и картинкой
final class ProfileMainHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var coinsView = MainProfileCoinsView()
    private lazy var profileView = AppView(type: .profile)

    // MARK: - Other Properties
    private let height: CGFloat = 40

    var onButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileView.layer.cornerRadius = frame.height / 2
    }
}

// MARK: - Public methods
extension ProfileMainHeaderView {
    func updateCoinsLabel(with coins: Int) {
        coinsView.updateCoinsLabel(with: coins)
    }
}

// MARK: - Setup UI
private extension ProfileMainHeaderView {
    func setupUI() {
        addSubviews(profileView, coinsView)
        setupLayout()
    }

    func setupLayout() {
        setupProfileImageViewLayout()
        setupCoinsViewLayout()
    }

    // Констреинты coinsView
    func setupCoinsViewLayout() {
        coinsView.setLocalConstraints(bottom: 0, left: 0, right: 0)
    }

    func setupProfileImageViewLayout() {
        profileView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

// MARK: - Setup Tap gesture
private extension ProfileMainHeaderView {
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc func profileButtonTapped() {
        onButtonTapped?()
    }
}
