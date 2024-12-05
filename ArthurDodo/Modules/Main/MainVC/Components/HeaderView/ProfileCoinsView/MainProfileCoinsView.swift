import UIKit

// Это вью на главном экране в хэдере справа: синяя вью с додокоинами и монеткой
final class MainProfileCoinsView: UIView {

    // MARK: - Properties
    private lazy var coinsLabel = AppLabel(type: .smallTitle)
    private lazy var coinsImageView = AppImageView(type: .dodoCoins)
    private lazy var contentStack = AppStackView([coinsLabel, coinsImageView], axis: .horizontal, spacing: 1)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension MainProfileCoinsView {
    func updateCoinsLabel(with coins: Int) {
        coinsLabel.text = "\(coins)"
    }
}

// MARK: - Setup UI
private extension MainProfileCoinsView {
    func setupUI() {
        setupUIElements()

        backgroundColor = AppColors.dodoCoinsBlue
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 15).isActive = true
        layer.cornerRadius = 5
        addSubviews(contentStack)

        setupLayout()
    }

    func setupUIElements() {
        coinsLabel.adjustsFontSizeToFitWidth = true
        coinsLabel.textAlignment = .center
        coinsLabel.numberOfLines = 1
    }

    // Констреинты StackView
    func setupLayout() {
        contentStack.setConstraints(allInsets: 1)
        coinsImageView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
