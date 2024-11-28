import UIKit

// Ячейка таблицы с адресами на экране адресов
final class AddressTableViewCell: UITableViewCell {

    // MARK: - Properties
    private lazy var titleLabel = AppLabelDS(type: .name)

    private let cornerRadius: CGFloat = 10
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

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

        setupAccessoryView()

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
