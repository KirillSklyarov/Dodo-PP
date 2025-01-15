import UIKit

// Ячейка с названиями категорий на основном экране
final class CategoryViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .basicTitle)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }

    func configHeader(_ titleText: String? = nil, indexPath: IndexPath) {
        titleLabel.text = titleText

        if indexPath == IndexPath(row: 0, section: 0) {
            titleLabel.textColor = UIColor.white
        } else {
            titleLabel.textColor = AppColors.grayFont
        }
    }
}

// MARK: - Setup UI
private extension CategoryViewCell {
    func setupUI() {
        contentView.addSubviews(titleLabel)
        setupLayout()
    }

    func setupLayout() {
        titleLabel.setConstraints(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))

        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
