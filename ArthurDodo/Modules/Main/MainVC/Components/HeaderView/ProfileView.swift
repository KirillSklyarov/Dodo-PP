import UIKit

// Это кнопка профиля на главном экране с додокоинами и картинкой
final class ProfileMainHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var coinsLabel = AppLabelDS(type: .coinsTitle)
    private lazy var coinsImageView = AppImageView(viewImage: .common(.dodoCoins), isSystem: false)

    private lazy var coinsStackView = AppStackView([coinsLabel, coinsImageView], axis: .horizontal, spacing: 1)

    private lazy var coinsView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.dodoCoinsBlue
        view.layer.masksToBounds = true
        view.heightAnchor.constraint(equalToConstant: 15).isActive = true
        view.layer.cornerRadius = 5
        view.addSubviews(coinsStackView)
        return view
    }()
    private lazy var profileView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.grayFont
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Other Properties
    private let height: CGFloat = 40

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
        coinsLabel.text = "\(coins)"
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
        coinsStackViewLayout()
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

    // Констреинты coinsStackView
    func coinsStackViewLayout() {
        NSLayoutConstraint.activate([
            coinsStackView.leadingAnchor.constraint(equalTo: coinsView.leadingAnchor, constant: 1),
            coinsStackView.trailingAnchor.constraint(equalTo: coinsView.trailingAnchor),

            coinsStackView.topAnchor.constraint(equalTo: coinsView.topAnchor, constant: 1),
            coinsStackView.bottomAnchor.constraint(equalTo: coinsView.bottomAnchor, constant: -1),

            coinsImageView.widthAnchor.constraint(equalTo: coinsStackView.heightAnchor),
        ])
    }

    func profileImageViewLayout() {
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: topAnchor),
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
