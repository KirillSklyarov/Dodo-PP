import UIKit

final class AppBlurView: UIVisualEffectView {

    private let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)

    override init(effect: UIVisualEffect?) {
        super.init(effect: effect ?? blurEffect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
