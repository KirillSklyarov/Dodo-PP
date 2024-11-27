import UIKit

final class AppButton: UIButton {

    init(frame: CGRect = .zero, type: Button? = nil, title: String? = nil, imageColor: AppColorsEnum? = nil, target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        super.init(frame: frame)
        self.setTitle(title, for: .normal)
        setImage(type: type, imageColor: imageColor)
        setupAction(target: target, action: action, for: event)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppButton {
    func setImage(type: Button?, imageColor: AppColorsEnum?) {
        guard let type, let imageColor else { return }
        let image = UIImage(systemName: type.rawValue)?.withTintColor(imageColor.color, renderingMode: .alwaysOriginal)
        setImage(image, for: .normal)
    }

    func setupAction(target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        addTarget(target, action: action, for: event)

    }
}



//private extension AppImageView {
//    // Если картинка квадратная, то тут выставляем размер
//    func setupLayout(squareSize: CGFloat?) {
//        if let squareSize {
//            heightAnchor.constraint(equalToConstant: squareSize).isActive = true
//            widthAnchor.constraint(equalToConstant: squareSize).isActive = true
//        }
//    }
//}
