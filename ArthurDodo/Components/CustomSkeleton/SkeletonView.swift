import UIKit

final class SkeletonView: UIView {

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
        setupAnimation()
    }
}

// MARK: - Setup UI
private extension SkeletonView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        setupGradient()
        setupAnimation()
    }
}

// MARK: - Setup gradient&animation
private extension SkeletonView {
    // Настраиваем градиент
    func setupGradient() {
        gradientLayer.colors = [AppColors.backgroundGray.cgColor,
                                UIColor.lightGray.cgColor,
                                AppColors.backgroundGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.35, 0.5, 0.65] // Тут мы устанавливаем ширину каждого цвета в градиенте (сейчас переход gray->lightGray - это 0.15, и столько же обратно - 0.15)
        layer.addSublayer(gradientLayer)
    }

    // Настраиваем анимацию
    func setupAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -frame.width
        animation.toValue = frame.width
        animation.duration = 2.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
}
