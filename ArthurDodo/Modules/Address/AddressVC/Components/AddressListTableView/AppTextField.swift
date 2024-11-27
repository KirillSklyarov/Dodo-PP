import UIKit

final class AppTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: .zero)

        let placeholder = "1"
        textColor = .white
        font = AppFonts.semibold14
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: AppColors.grayFont])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
