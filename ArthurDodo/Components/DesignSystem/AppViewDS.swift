import UIKit

enum AppViewType {
    case profile
    case separator
    case details
}

final class AppViewDS: UIView {

    init(type: AppViewType) {
        super.init(frame: .zero)
        configure(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppViewDS {
    func configure(_ type: AppViewType) {
        switch type {
        case .profile:
            backgroundColor = AppColors.grayFont
            layer.masksToBounds = true
        case .separator:
            backgroundColor = AppColors.buttonGray
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        case .details:
            backgroundColor = AppColors.backgroundGray
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }
    }
}
