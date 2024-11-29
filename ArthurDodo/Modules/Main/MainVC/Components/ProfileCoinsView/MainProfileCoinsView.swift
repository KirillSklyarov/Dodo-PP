import UIKit

final class MainProfileCoinsView: UIView {

    // MARK: - Properties
    private lazy var coinsLabel = AppLabel(type: .coinsTitle)
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
        heightAnchor.constraint(equalToConstant: 15).isActive = true
        layer.cornerRadius = 5
        addSubviews(contentStack)

        setupLayout()
    }

    // Констреинты StackView
    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),

            coinsImageView.widthAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}
