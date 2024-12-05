import UIKit

final class ErrorCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var iconImageView = AppImageView(type: .errorXMark)
    private lazy var titleLabel = AppLabel(type: .header, text: "Не удалось загрузить данные")
    private lazy var retryButton = AppButtons(type: .errorRetry)
    private lazy var contentStackView = AppStackView([iconImageView, titleLabel, retryButton], axis: .vertical, alignment: .center, distribution: .equalSpacing)

    // MARK: - Properties
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
        layer.cornerRadius = 14
        clipsToBounds = true
        backgroundColor = AppColors.backgroundGray

        contentView.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints(allInsets: 10)
    }
}

// MARK: - Setup actions
private extension ErrorCollectionViewCell {
    @objc func retryButtonTapped() {
        onRetryButtonTapped?()
    }
}
