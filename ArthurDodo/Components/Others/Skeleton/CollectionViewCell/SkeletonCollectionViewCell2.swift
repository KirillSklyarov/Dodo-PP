import UIKit

final class SkeletonCollectionViewCell2: UICollectionViewCell {

    // MARK: - Properties
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
private extension SkeletonCollectionViewCell2 {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 10
        clipsToBounds = true
        setBorder(AppColors.buttonOrange, borderWidth: 3)

        setupGradient()
        setupAnimation()
    }
}

// MARK: - Setup gradient&animation
private extension SkeletonCollectionViewCell2 {
    // Настраиваем градиент
    func setupGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        let angle = 45 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        layer.mask = gradientLayer
    }

    // Настраиваем анимацию
    func setupAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -frame.width
        animation.toValue = frame.width
        animation.repeatCount = Float.infinity
        animation.duration = 3

        gradientLayer.add(animation, forKey: "myAnimation")
    }
}

