import UIKit

// Ячейка таблицы с адресами на экране адресов
final class AddressTableViewCell: UITableViewCell {

    // MARK: - Properties
    private lazy var titleLabel = AppLabel(type: .basicTitle)

    private let cornerRadius: CGFloat = 10

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressTableViewCell {
    func configureCell(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Setup UI
private extension AddressTableViewCell {
    func setupCell() {
        backgroundColor = AppColors.backgroundGray
        contentView.addSubviews(titleLabel)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        selectionStyle = .none

        setAccessoryView(.chevron)

        setupLayout()
    }

    func setupLayout() {
        titleLabel.setConstraints(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
}
