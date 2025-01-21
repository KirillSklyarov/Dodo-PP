import UIKit
import AppUIComponentsSPM

// Это вью на главном экране в хэдере справа: синяя вью с додокоинами и монеткой
final class MainProfileCoinsView: UIView {

    // MARK: - Properties
    private lazy var coinsLabel = AppLabel(type: .tinyTitle)
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
        backgroundColor = AppColors.dodoCoinsBlue
        layer.masksToBounds = true
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 15).isActive = true
        addSubviews(contentStack)

        setupLayout()
    }

    // Констреинты StackView
    func setupLayout() {
        contentStack.setConstraints(allInsets: 1)
        coinsImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
    }
}
