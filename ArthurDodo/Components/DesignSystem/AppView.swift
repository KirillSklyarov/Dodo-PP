import UIKit

enum AppViewType {
    case profile
    case separator
    case details
    case roundedTopView
}

final class AppView: UIView {

    init(type: AppViewType) {
        super.init(frame: .zero)
        configure(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppView {
    func configure(_ type: AppViewType) {
        switch type {
        case .profile:
            backgroundColor = AppColors.grayFont
            layer.masksToBounds = true
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            widthAnchor.constraint(equalToConstant: 40).isActive = true
        case .separator:
            backgroundColor = AppColors.buttonGray
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        case .details:
            backgroundColor = AppColors.backgroundGray
            layer.cornerRadius = 10
            layer.masksToBounds = true
        case .roundedTopView:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            layer.cornerRadius = frame.height / 2
            clipsToBounds = true
        }
    }
}
