import UIKit

final class ErrorCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private let xmarkImageSize: CGFloat = 65
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let cornerRadius: CGFloat = 14

    var onRetryButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "xmark.circle")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: xmarkImageSize).isActive = true
        return imageView
    }()
    private lazy var containerImageView: UIView = {
        let view = UIView()
        view.addSubviews(iconImageView)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold26
        label.numberOfLines = 0
        label.text = "Не удалось загрузить данные"
        label.textColor = AppColors.grayFont
        label.textAlignment = .center
        return label
    }()
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString("Повторить", attributes: AttributeContainer([
            .font: AppFonts.bold16,
            .foregroundColor: AppColors.grayFont])
        )
        config.baseBackgroundColor = AppColors.buttonGray
        config.cornerStyle = .capsule
        button.configuration = config
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [containerImageView, titleLabel, retryButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

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
        setupContainerViewLayout()
        setupContainerImageViewLayout()
    }

    func setupContainerViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset),
        ])
    }

    func setupContainerImageViewLayout() {
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: containerImageView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: containerImageView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor)
        ])
    }
}

// MARK: - Setup actions
private extension ErrorCollectionViewCell {
    @objc func retryButtonTapped() {
        onRetryButtonTapped?()
    }
}
