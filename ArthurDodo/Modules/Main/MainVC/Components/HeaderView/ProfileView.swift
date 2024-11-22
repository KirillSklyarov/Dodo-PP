import UIKit

final class ProfileMainHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var coinsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.semibold12
        label.adjustsFontSizeToFitWidth = true
        label.text = "91"
        label.textAlignment = .center
        return label
    }()
    private lazy var coinsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dodoCoinsImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
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
    private lazy var profileImageView: UIView = {
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
        profileImageView.layer.cornerRadius = frame.height / 2
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
        addSubviews(profileImageView, coinsView)

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

            coinsImageView.widthAnchor.constraint(equalTo: coinsStackView.widthAnchor, multiplier: 0.4),
        ])
    }

    func profileImageViewLayout() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
