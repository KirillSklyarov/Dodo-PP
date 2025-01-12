import UIKit

final class PreferredPaymentMethodTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var methodImage = AppImageView(type: .smallView)
    private lazy var titleLabel = AppLabel(type: .maxiTitle)
    private lazy var contentStack = AppStackView([methodImage, titleLabel], axis: .horizontal, spacing: 10, alignment: .center)

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
        setAccessoryView(.chevron)

        contentView.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
}

// MARK: - Setup actions
private extension PreferredPaymentMethodTableViewCell {

}

