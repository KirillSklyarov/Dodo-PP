import UIKit

final class CartButton: UIButton {

    // MARK: - Properties
    private var totalPrice = 0
    private let buttonHeight: CGFloat = 50

    var isCart: Bool
    var onButtonTapped: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, isHidden: Bool = false, title: String? = nil, isNeedImage: Bool = false, isCart: Bool = false) {
        self.isCart = isCart
        super.init(frame: frame)
        configButton(isHidden: isHidden)
        setupLayout()
        if let title { setNewTitle(title) }
        if !isNeedImage { self.configuration?.image = nil }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setNewTitle(_ title: String) {
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold18])
        )
    }

    func setNewPrice(_ price: Int) {
        let title = "\(price) ₽"
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold18]))
    }

    func updateCart(with totalPrice: Int) {
        setNewPrice(totalPrice)
        showOrHideCartButton(totalPrice)
    }
}

// MARK: - Supporting methods
private extension CartButton {
    func showOrHideCartButton(_ totalPrice: Int) {
        totalPrice > 0 ? showCartButton() : hideCartButton()
    }

    func hideCartButton() {
        isHidden = true
    }

    func showCartButton() {
        isHidden = false
    }
}

// MARK: - Setup UI
private extension CartButton {
    func configButton(isHidden: Bool) {
        let image = UIImage(systemName: "cart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let title = "0 ₽"

        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        config.title = title
        config.image = image
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold18]
        ))
        config.background.backgroundColor = AppColors.buttonOrange
        config.cornerStyle = .capsule
        configuration = config

        self.isHidden = isHidden
        addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }

    @objc func cartButtonTapped() {
        onButtonTapped?()
    }
}
