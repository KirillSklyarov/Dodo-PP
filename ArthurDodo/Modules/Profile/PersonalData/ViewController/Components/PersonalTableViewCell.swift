import UIKit
import AppUIComponentsSPM

final class PersonalTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .basicTitle, textColor: AppColors.grayFont)
    private lazy var dataLabel = AppLabel(type: .basicTitle)
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
        contentStack.setConstraints(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }

    func setupConfigureContentStack() -> UIStackView {
        let labelsStack = AppStackView([titleLabel, dataLabel], axis: .vertical, spacing: 5)
        let contentStack = AppStackView([labelsStack, switchLabel], axis: .horizontal, alignment: .center)
        return contentStack
    }
}
