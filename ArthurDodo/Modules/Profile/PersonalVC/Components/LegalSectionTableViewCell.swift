import UIKit

final class LegalSectionTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabelDS(type: .legalTitle)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ row: Int) {
        switch row {
        case 0: titleLabel.text = "Язык приложения"
        case 1: titleLabel.text = "Правовые документы"
        default: break
        }
    }
}

// MARK: - Setup UI
private extension LegalSectionTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        let image = UIImage(systemName: "chevron.right")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        let chevronView = UIImageView(image: image)
        accessoryView = chevronView

        contentView.addSubviews(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

