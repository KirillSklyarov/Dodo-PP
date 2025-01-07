import UIKit

final class AppActivityIndicator: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style = .large) {
        super.init(style: style)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppActivityIndicator {
    func setupUI() {
        color = AppColors.buttonOrange
    }
}
