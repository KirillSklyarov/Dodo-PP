import UIKit

final class CustomSkeletonViewBorder: UIView {

    // MARK: - Properties
    private lazy var fillView = AppView(type: .details)
    private var gradientLayer = CAGradientLayer()

    private let viewHeight: CGFloat = 200

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
private extension CustomSkeletonViewBorder {
    func setupUI() {
        layer.cornerRadius = 10
        backgroundColor = AppColors.backgroundGray
        heightAnchor.constraint(greaterThanOrEqualToConstant: viewHeight).isActive = true

        setupGradient()

        addSubviews(fillView)
        setupLayout()
    }

    func setupLayout() {
        fillView.setConstraints(allInsets: 3)
    }
}

// MARK: - Setup gradient&animation
private extension CustomSkeletonViewBorder {
    // Настраиваем градиент
    func setupGradient() {
        gradientLayer.locations = [0, 0.25, 0.5, 0.75, 1]
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor,
            UIColor.green.cgColor,
            UIColor.systemPurple.cgColor
        ]

        layer.addSublayer(gradientLayer)
    }

    // Настраиваем анимацию
    func setupAnimation() {
        let startPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnimation.fromValue = CGPoint(x: 2, y: -1)
        startPointAnimation.toValue = CGPoint(x: 0, y: 1)

        let endPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnimation.fromValue = CGPoint(x: 1, y: 0)
        endPointAnimation.toValue = CGPoint(x: -1, y: 2)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [startPointAnimation, endPointAnimation]
        animationGroup.duration = 4
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)

        gradientLayer.add(animationGroup, forKey: "borderShimmerAnimation")
    }
}
