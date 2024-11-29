import UIKit

final class AddressListTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var orangePoint = AppImageView(type: .addressPoint)
    private lazy var titleLabel = AppLabel(type: .addressTitle)
    private lazy var editAddressButton = AppButtons(type: .mapEdit)

    // MARK: - Properties
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    var onEditAddressButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods (configure cell)
extension AddressListTableViewCell {
    func configureCell(title: String, isMain: Bool) {
        let circleImage = setCorrectCircleImage(isMain)
        orangePoint.image = circleImage

        titleLabel.text = title
        titleLabel.textColor = AppColors.grayFont

        let pencilImage = UIImage(systemName: "pencil")?.withTintColor(AppColors.buttonGray, renderingMode: .alwaysOriginal)
        editAddressButton.setImage(pencilImage, for: .normal)
    }

    func configureLastCell(title: String) {
        let pointImage = UIImage(systemName: "drop")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        orangePoint.image = pointImage
        orangePoint.transform = CGAffineTransform(scaleX: 1, y: -1)

        titleLabel.text = title
        titleLabel.textColor = AppColors.buttonOrange
        let plusImage = UIImage(systemName: "plus")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        editAddressButton.setImage(plusImage, for: .normal)
    }
}

// MARK: - Supporting methods
extension AddressListTableViewCell {
    func setCorrectCircleImage(_ isMain: Bool) -> UIImage? {

        let image: UIImage? = if isMain {
            UIImage(systemName: "record.circle.fill")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        } else {
           UIImage(systemName: "circle.fill")?.withTintColor(AppColors.backgroundGray, renderingMode: .alwaysOriginal)
        }
        return image
    }

    func selectedCell() {
        let circleImage = setCorrectCircleImage(true)
        orangePoint.image = circleImage
    }

    func deSelectedCell() {
        let circleImage = setCorrectCircleImage(false)
        orangePoint.image = circleImage
    }
}

// MARK: - Setup UI
private extension AddressListTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        accessoryView = editAddressButton

        let contentStack = AppStackView([orangePoint, titleLabel], axis: .horizontal, spacing: 10)

        contentView.addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }
}

// MARK: - Setup actions
private extension AddressListTableViewCell {
    func setupAction() {
        setupPencilButtonAction()
    }

    func setupPencilButtonAction() {
        editAddressButton.onButtonTapped = { [weak self] in
            self?.onEditAddressButtonTapped?()
        }
    }
}
