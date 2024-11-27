import UIKit

final class SkeletonCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var darkPlaceholderTitle = AppLabel(text: "Загружаем", textColor: .darkGray, font: .bold(size: 30), alignment: .center, numberOfLines: 1, adjustsFontSizeToFitWidth: true)

    private lazy var whitePlaceholderTitle = AppLabel(text: "Загружаем", textColor: .white, font: .bold(size: 30), alignment: .center, numberOfLines: 1, adjustsFontSizeToFitWidth: true)

    private var gradientLayer = CAGradientLayer()

    // MARK: - Properties
    private let leftInset: CGFloat = 5
    private let rightInset: CGFloat = -5

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

// MARK: - Setup UI
private extension SkeletonCollectionViewCell {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 10
        clipsToBounds = true
        setBorder(AppColors.buttonGray)

        contentView.addSubviews(darkPlaceholderTitle, whitePlaceholderTitle)

        setupLayout()
        setupGradient()
        setupAnimation()
    }
}

// MARK: - Setup layout
private extension SkeletonCollectionViewCell {
    // Настраиваем расположении
    func setupLayout() {
        setupDarkTitleLayout()
        setupLightTitleLayout()
    }

    func setupDarkTitleLayout() {
        NSLayoutConstraint.activate([
            darkPlaceholderTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            darkPlaceholderTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            darkPlaceholderTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            darkPlaceholderTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset)
        ])
    }

    func setupLightTitleLayout() {
        NSLayoutConstraint.activate([
            whitePlaceholderTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            whitePlaceholderTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            whitePlaceholderTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            whitePlaceholderTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset)
        ])
    }
}

// MARK: - Setup gradient&animation
private extension SkeletonCollectionViewCell {
    // Настраиваем градиент
    func setupGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        let angle = 45 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        whitePlaceholderTitle.layer.mask = gradientLayer
    }

    // Настраиваем анимацию
    func setupAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -frame.width
        animation.toValue = frame.width
        animation.repeatCount = .infinity
        animation.duration = 2.5

        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
}
