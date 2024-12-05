import UIKit

final class SkeletonTableViewCell: UITableViewCell {

    // MARK: - Properties
    private lazy var darkPlaceholderTitle = AppLabel(type: .header, text: "Загружаем", textColor: .darkGray)
    private lazy var whitePlaceholderTitle = AppLabel(type: .header, text: "Загружаем")
    private var gradientLayer = CAGradientLayer()

    // MARK: - Init
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
private extension SkeletonTableViewCell {
    func setupUI() {
        backgroundColor = AppColors.backgroundBlack
        layer.cornerRadius = 10
        clipsToBounds = true
        setBorder(AppColors.backgroundGray)

        contentView.addSubviews(darkPlaceholderTitle, whitePlaceholderTitle)

        setupLayout()
        setupGradient()
        setupAnimation()
    }

    // Настраиваем расположении
    func setupLayout() {
        darkPlaceholderTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        darkPlaceholderTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        whitePlaceholderTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        whitePlaceholderTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

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
        animation.repeatCount = Float.infinity
        animation.duration = 3

        gradientLayer.add(animation, forKey: "myAnimation")
    }
}
