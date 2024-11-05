import UIKit

final class DodoCoinsView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular18
        label.numberOfLines = 1
        return label
    }()
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular18
        label.numberOfLines = 1
        return label
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    init(frame: CGRect = .zero, textColor: UIColor = .white) {
        super.init(frame: frame)
        setupUI()
        setTextColor(textColor)
    }

    init(frame: CGRect = .zero, title: String, value: String, textColor: UIColor = .white) {
        super.init(frame: frame)
        setupUI()
        titleLabel.text = title
        valueLabel.text = value
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
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Supporting methods
private extension DodoCoinsView {
    func setTextColor(_ color: UIColor) {
        titleLabel.textColor = color
        valueLabel.textColor = color
    }
}
