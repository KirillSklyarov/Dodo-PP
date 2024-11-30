import UIKit

final class CustomSkeletonView: UIView {

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
private extension CustomSkeletonView {
    func setupUI() {
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        backgroundColor = AppColors.backgroundGray
        setupGradient()
        setupAnimation()
    }
}

// MARK: - Setup gradient&animation
private extension CustomSkeletonView {
    // Настраиваем градиент
    func setupGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        gradientLayer.colors = [
            UIColor.darkGray.withAlphaComponent(0.8).cgColor,
            UIColor.gray.withAlphaComponent(0.7).cgColor,
            UIColor.darkGray.withAlphaComponent(0.8).cgColor
        ]

        gradientLayer.locations = [0.0, 0.5, 1.0]  // Тут мы устанавливаем ширину каждого цвета в градиенте (сейчас переход lightGray->white - это 0.5, и столько же обратно - 0.5)

        layer.addSublayer(gradientLayer)
    }

    func setupAnimation() {
        // Анимация для движения "света" по градиенту
        let shimmerAnimation = CABasicAnimation(keyPath: "locations")
        shimmerAnimation.fromValue = [-0.3, -0.15, 0.0] // Начальная позиция анимации
        shimmerAnimation.toValue = [1.0, 1.15, 1.3]     // Конечная позиция анимации
        shimmerAnimation.duration = 3               // Длительность анимации
        shimmerAnimation.repeatCount = .infinity        // Бесконечное повторение
        shimmerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        gradientLayer.add(shimmerAnimation, forKey: "shimmerEffect")
    }
}
