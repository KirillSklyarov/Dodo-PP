import UIKit

final class DeliveryVCLabel: UILabel {

    init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame)
        setupUI(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DeliveryVCLabel {
    func setupUI(_ title: String) {
        font = AppFonts.semibold20
        textColor = .white
        text = title
    }
}
