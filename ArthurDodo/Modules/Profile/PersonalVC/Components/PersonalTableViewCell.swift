import UIKit

final class PersonalTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabelDS(type: .promoTitle)
    private lazy var dataLabel = AppLabelDS(type: .name)
    private lazy var switchLabel = AppSwitch()
    private lazy var contentStack = setupConfigureContentStack()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(title: String, data: String) {
        if title != "Разрешить уведомления" {
            titleLabel.text = title
            dataLabel.text = data
        } else {
            designPushCell(title, data)
        }
    }

    private func designPushCell(_ title: String, _ data: String) {
        titleLabel.text = title
        titleLabel.textColor = .white
        dataLabel.text = "Пуши, письма на почту, СМС"
        dataLabel.textColor = AppColors.grayFont
        switchLabel.isHidden = false
        if data == "false" {
            switchLabel.isOn = false
        } else {
            switchLabel.isOn = true
        }
    }
}

// MARK: - Setup UI
private extension PersonalTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupConfigureContentStack() -> UIStackView {
        let labelsStack = AppStackView([titleLabel, dataLabel], axis: .vertical, spacing: 5)
        let contentStack = AppStackView([labelsStack, switchLabel], axis: .horizontal, alignment: .center)
        return contentStack
    }
}
