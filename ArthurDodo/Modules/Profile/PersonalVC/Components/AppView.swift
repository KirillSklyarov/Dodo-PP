import UIKit

final class AppView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
