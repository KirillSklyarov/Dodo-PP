import UIKit

final class LegalSectionTableViewCell: UITableViewCell {

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
        titleLabel.textAlignment = .left
        backgroundColor = .clear
        selectionStyle = .none
        setAccessoryView(.chevron)

        contentView.addSubviews(titleLabel)

        setupLayout()
    }


    func setupLayout() {
        titleLabel.setLocalConstraints(left: 0, right: 0)
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

