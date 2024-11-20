import UIKit

final class PreferredPaymentMethodTableViewCell: UITableViewCell {

    // MARK: - Properties
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
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [methodImage, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
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

    func setupAccessoryView() {
        let image = UIImage(systemName: "chevron.right")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        let chevronView = UIImageView(image: image)
        accessoryView = chevronView
    }
}

// MARK: - Setup actions
private extension PreferredPaymentMethodTableViewCell {

}

