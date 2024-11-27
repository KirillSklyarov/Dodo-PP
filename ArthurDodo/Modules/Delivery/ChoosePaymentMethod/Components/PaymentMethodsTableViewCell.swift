import UIKit

final class PaymentMethodsTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var methodImage = AppImageView(squareSize: imageSize)
    private lazy var titleLabel = AppLabel(textColor: .white, font: .semibold(size: 20))

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10
    private let imageSize: CGFloat = 25

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
extension PaymentMethodsTableViewCell {
    func configureCell(title: String, image: UIImage?, isMainMethod: Bool) {
        methodImage.image = image
        titleLabel.text = title

        // Если способ оплаты главный, то выделяем его галкой
        if isMainMethod {
            setCheckMarkAccessoryView()
        }
    }
}

// MARK: - Supporting methods
private extension PaymentMethodsTableViewCell {

}

// MARK: - Setup UI
private extension PaymentMethodsTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        let contentStack = AppStackView([methodImage, titleLabel], axis: .horizontal, spacing: 10)

        contentView.addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }

    // Выделяет выбранный метод галкой
    func setCheckMarkAccessoryView() {
        let image = UIImage(systemName: "checkmark")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        let checkmarkView = UIImageView(image: image)
        accessoryView = checkmarkView
    }
}

// MARK: - Setup actions
private extension PaymentMethodsTableViewCell {

}

