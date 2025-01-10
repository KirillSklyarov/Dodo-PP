import UIKit

final class AppSwitch: UISwitch {

    init(isHidden: Bool = true) {
        super.init(frame: .zero)
        isOn = false
        self.isHidden = isHidden
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
