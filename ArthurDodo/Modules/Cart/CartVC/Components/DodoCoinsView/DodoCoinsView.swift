import UIKit

final class DodoCoinsView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .basicTitle)
    private lazy var valueLabel = AppLabel(type: .basicTitle)
    private lazy var contentStack = AppStackView([titleLabel, valueLabel], axis: .horizontal, distribution: .equalSpacing)

    // MARK: - Init
    init(frame: CGRect = .zero, title: String? = nil, value: String? = nil, textColor: UIColor = .white) {
        super.init(frame: frame)
        setupUI()
        setText(title: title, value: value)
        setTextColor(textColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension DodoCoinsView {
    func setNewCountValue(_ count: Int) {
        let item = "товар".pluralize(for: count)
        titleLabel.text = "\(count) \(item)"
    }

    func setTotalPrice(_ totalPrice: Int) {
        valueLabel.text = "\(totalPrice) ₽"
    }
}

// MARK: - Setup UI
private extension DodoCoinsView {
     func setupUI() {
        addSubviews(contentStack)
        setupLayout()
    }

     func setupLayout() {
         contentStack.setConstraints()
    }
}

// MARK: - Supporting methods
private extension DodoCoinsView {
    // Устанавливает текст
    func setText(title: String?, value: String?) {
        if let title, let value {
            titleLabel.text = title
            valueLabel.text = value
        }
    }

    // Устанавливает цвет текста
    func setTextColor(_ color: UIColor) {
        titleLabel.textColor = color
        valueLabel.textColor = color
    }
}
