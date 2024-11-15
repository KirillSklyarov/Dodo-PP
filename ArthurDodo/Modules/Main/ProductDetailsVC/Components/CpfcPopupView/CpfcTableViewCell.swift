import UIKit

final class CpfcTableViewCell: UITableViewCell {

    // MARK: - Properties
    var onPriceButtonTapped: ( (String) -> Void )?

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular14
        label.textColor = .white
        return label
    }()
    private lazy var cpfcValueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular14
        label.textColor = .white
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

    // MARK: - Public method
    func configureCell(title: String, cpfcValue: String) {
        titleLabel.text = title
        cpfcValueLabel.text = cpfcValue
    }
}

// MARK: - Setup UI
private extension CpfcTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubviews(titleLabel, cpfcValueLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            cpfcValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cpfcValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
