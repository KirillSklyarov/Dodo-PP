import UIKit

final class EditCartButtonView: UIView {

    // MARK: - UI Properties
    private lazy var blurView = AppBlurView()
    private lazy var cartButton = CartButton(title: "Готово")
    private lazy var priceLabel = AppLabel(textColor: .white, font: .bold(size: 22))
    private lazy var contentStackView = AppStackView( [priceLabel, UIView(), cartButton], axis: .horizontal, alignment: .top)

    // MARK: - Properties
    private let viewHeight: CGFloat = 90
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
    private let bottomInset: CGFloat = -10

    private var currentPrice = 0

    var onCartButtonTapped: ( () -> Void )?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension EditCartButtonView {
    func getHeight() -> CGFloat {
        viewHeight
    }

    func getCurrentPrice() -> Int {
        currentPrice
    }

    func updatePriceLabel(_ price: Int) {
        priceLabel.text = "\(price) ₽"
    }
}

// MARK: - Setup UI
private extension EditCartButtonView {
    func configUI() {
        addSubviews(blurView, contentStackView)
        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        setupBlurConstraints()
        setupContentStackConstraints()
        setupElementsConstraints()
    }

    func setupBlurConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupContentStackConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset),
        ])
    }

    func setupElementsConstraints() {
        setCorrectButtonHeight()

        NSLayoutConstraint.activate([
            cartButton.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.4),
            priceLabel.centerYAnchor.constraint(equalTo: cartButton.centerYAnchor),
        ])
    }
}

// MARK: - Setup Actions
private extension EditCartButtonView {
    func setupActions() {
        cartButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            onCartButtonTapped?()
        }
    }
}

// MARK: - Supporting methods
private extension EditCartButtonView {
    func setCorrectButtonHeight() {
        let newHeight = contentStackView.frame.height * 0.7
        cartButton.setNewHeight(newHeight)
    }
}

