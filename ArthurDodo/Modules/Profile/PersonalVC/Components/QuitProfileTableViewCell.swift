import UIKit

final class QuitProfileTableViewCell: UITableViewCell {
    
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
    func configureCell(_ title: String, _ titleColor: UIColor = .white) {
        titleLabel.text = title
        titleLabel.textColor = titleColor
    }
}

// MARK: - Setup UI
private extension QuitProfileTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubviews(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
