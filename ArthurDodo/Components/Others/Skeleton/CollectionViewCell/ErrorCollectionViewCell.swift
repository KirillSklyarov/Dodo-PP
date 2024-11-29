import UIKit

final class ErrorCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var iconImageView = AppImageView(type: .errorXMark)
    private lazy var titleLabel = AppLabel(type: .header, text: "Не удалось загрузить данные")
    private lazy var retryButton = AppButtons(type: .errorRetry)
    private lazy var contentStackView = AppStackView([iconImageView, titleLabel, retryButton], axis: .vertical, alignment: .center, distribution: .equalSpacing)

    // MARK: - Properties
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let cornerRadius: CGFloat = 14

    var onRetryButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension ErrorCollectionViewCell {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        backgroundColor = AppColors.backgroundGray

        contentView.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
    }

    func setupContentStackViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset),
        ])
    }
}

// MARK: - Setup actions
private extension ErrorCollectionViewCell {
    @objc func retryButtonTapped() {
        onRetryButtonTapped?()
    }
}
