import UIKit

final class AppSwitch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        isOn = false
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
