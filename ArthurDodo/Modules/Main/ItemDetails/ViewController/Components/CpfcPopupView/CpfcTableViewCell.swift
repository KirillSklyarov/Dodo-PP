import UIKit
import AppUIComponentsSPM

final class CpfcTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .smallTitle)
    private lazy var cpfcValueLabel = AppLabel(type: .smallTitle, alignment: .right)

    private lazy var contentStack = AppStackView([titleLabel, cpfcValueLabel], axis: .horizontal)

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

        contentView.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints()
    }
}
