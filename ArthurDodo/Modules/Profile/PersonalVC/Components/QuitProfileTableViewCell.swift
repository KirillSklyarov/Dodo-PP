import UIKit

// Секция выйти из профиля личных данных на экране профиля
final class QuitProfileTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .maxiTitle)

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

        setupLayout()
    }

    func setupLayout() {
        titleLabel.setLocalConstraints(left: 0, right: 0)
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
