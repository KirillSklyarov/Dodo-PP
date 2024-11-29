import UIKit

final class PreferredPaymentMethodTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var methodImage = AppImageViewDS(type: .smallView)
    private lazy var titleLabel = AppLabelDS(type: .legalTitle)
    private lazy var contentStack = AppStackView([methodImage, titleLabel], axis: .horizontal, spacing: 10)

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods (configure cell)
extension PreferredPaymentMethodTableViewCell {
    func configureCell(title: String, image: UIImage?) {
        methodImage.image = image
        titleLabel.text = title
    }
}

// MARK: - Supporting methods
private extension PreferredPaymentMethodTableViewCell {

}

// MARK: - Setup UI
private extension PreferredPaymentMethodTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        setupAccessoryView()

        contentView.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }
}

// MARK: - Setup actions
private extension PreferredPaymentMethodTableViewCell {

}

