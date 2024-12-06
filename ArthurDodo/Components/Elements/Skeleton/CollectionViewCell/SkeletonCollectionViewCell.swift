import UIKit

final class SkeletonCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var darkPlaceholderTitle = AppLabel(type: .header, text: "Загружаем", textColor: .darkGray)
    private lazy var whitePlaceholderTitle = AppLabel(type: .header, text: "Загружаем")
    private var gradientLayer = CAGradientLayer()

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
        darkPlaceholderTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        darkPlaceholderTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    func setupLightTitleLayout() {
        whitePlaceholderTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        whitePlaceholderTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
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
