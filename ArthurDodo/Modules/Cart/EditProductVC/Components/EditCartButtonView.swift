import UIKit

// Нижний блок с ценой и кнопкой на экране редактирования товара
final class EditCartButtonView: UIView {

    // MARK: - UI Properties
    private lazy var blurView = AppBlurView()
    private lazy var cartButton = AppButtons(type: .cartOrange, text: "Готово")
    private lazy var priceLabel = AppLabel(type: .smallHeader)
    private lazy var contentStackView = AppStackView( [priceLabel, cartButton], axis: .horizontal, alignment: .top)

    // MARK: - Properties
    private let viewHeight: CGFloat = 90
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
        blurView.setConstraints()
    }

    func setupContentStackConstraints() {
        contentStackView.setConstraints(insets: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
    }

    func setupElementsConstraints() {
        cartButton.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.4).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: cartButton.centerYAnchor).isActive = true
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
//private extension EditCartButtonView {
//    func setCorrectButtonHeight() {
//        let newHeight = contentStackView.frame.height * 0.7
//        cartButton.setNewHeight(newHeight)
//    }
//}

