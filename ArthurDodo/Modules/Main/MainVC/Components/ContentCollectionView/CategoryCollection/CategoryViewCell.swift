import UIKit

final class CategoryViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .categoryTitle)

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
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

    // MARK: - Private methods
    private func setupConstraints() {
        contentView.addSubviews(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
