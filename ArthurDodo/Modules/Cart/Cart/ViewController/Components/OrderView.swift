import UIKit

final class OrderView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .header)

    // MARK: - Init
    init(frame: CGRect = .zero, title: String? = nil) {
        super.init(frame: frame)
        configUI()
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension OrderView {
    func updateTitle(_ countOfItems: Int, totalPrice: Int) {
        let items = "товар".pluralize(for: countOfItems)
        let newText = "\(countOfItems) \(items) на \(totalPrice) ₽"
        titleLabel.text = newText
    }
}

// MARK: - Setup UI
private extension OrderView {
    func configUI() {
        addSubviews(titleLabel)
        setupLayout()
    }

    func setupLayout() {
        titleLabel.setConstraints()
    }
}
