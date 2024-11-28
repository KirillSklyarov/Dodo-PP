import UIKit

enum AppImageViewType {
    case payment
}

final class AppImageViewDS: UIImageView {

    init(type: AppImageViewType, image: UIImage? = nil) {
        super.init(frame: .zero)
        configure(type, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppImageViewDS {
    func configure(_ type: AppImageViewType, image: UIImage? = nil) {
        switch type {
        case .payment:
            self.image = image
            contentMode = .scaleAspectFit
            widthAnchor.constraint(equalToConstant: 24).isActive = true
        }
    }
}
