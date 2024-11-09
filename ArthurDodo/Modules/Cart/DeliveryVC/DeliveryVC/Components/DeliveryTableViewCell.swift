import UIKit

final class DeliveryTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier: String = "deliveryTableViewCell"

    private let cornerRadius: CGFloat = 10
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold18
        label.textColor = .white
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DeliveryTableViewCell {
    func configureCell(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Setup UI
private extension DeliveryTableViewCell {
    func setupCell() {
        backgroundColor = AppColors.backgroundGray
        contentView.addSubviews(titleLabel)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        selectionStyle = .none

        let image = UIImage(systemName: "chevron.right")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        let chevronView = UIImageView(image: image)
        accessoryView = chevronView

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}


