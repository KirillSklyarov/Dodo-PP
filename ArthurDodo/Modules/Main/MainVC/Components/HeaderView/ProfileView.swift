import UIKit

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
        viewLayout()
        profileImageViewLayout()
        coinsViewLayout()
    }

    // Констреинты самого view
    func viewLayout() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height),
            widthAnchor.constraint(equalTo: heightAnchor),
        ])
    }

    // Констреинты coinsView
    func coinsViewLayout() {
        NSLayoutConstraint.activate([
            coinsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coinsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coinsView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func profileImageViewLayout() {
        profileView.setConstraints()
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
