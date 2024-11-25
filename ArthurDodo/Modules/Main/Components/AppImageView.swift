import UIKit

final class AppImageView: UIImageView {

    init(frame: CGRect = .zero, systemImage: AppImages? = nil, tintColor: AppColorsEnum? = nil, squareSize: CGFloat? = nil) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        image = setupUI(systemImage: systemImage, tintColor: tintColor)
        setupLayout(squareSize: squareSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppImageView {
    // Настраиваем картинку, если она нужна
    func setupUI(systemImage: AppImages?, tintColor: AppColorsEnum?) -> UIImage? {
        guard let systemImage, let tintColor else { return nil }
        let image = UIImage(systemName: systemImage.image)?.withTintColor(tintColor.color, renderingMode: .alwaysOriginal)
        return image
    }

    // Если картинка квадратная, то тут выставляем размер
    func setupLayout(squareSize: CGFloat?) {
        if let squareSize {
            heightAnchor.constraint(equalToConstant: squareSize).isActive = true
            widthAnchor.constraint(equalToConstant: squareSize).isActive = true
        }
    }
}
