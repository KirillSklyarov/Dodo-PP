import UIKit

final class PaymentMethodsTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "PaymentMethodsTableViewCell"

    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10
    private let imageSize: CGFloat = 25

    // MARK: - UI Properties
    private lazy var methodImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.semibold20
        return label
    }()

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

        if isMainMethod {
            setAccessoryView()
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

        let contentStack = UIStackView(arrangedSubviews: [methodImage, titleLabel])
        contentStack.axis = .horizontal
        contentStack.spacing = 10

        contentView.addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }

    func setAccessoryView() {
        let image = UIImage(systemName: "checkmark")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        let checkmarkView = UIImageView(image: image)
        accessoryView = checkmarkView
    }
}

// MARK: - Setup actions
private extension PaymentMethodsTableViewCell {

}

