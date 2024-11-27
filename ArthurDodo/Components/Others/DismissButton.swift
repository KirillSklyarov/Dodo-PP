import UIKit

final class DismissButton: UIButton {

    var onDismissButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Закрыть", for: .normal)
        setTitleColor(AppColors.buttonOrange, for: .normal)
        addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissButtonTapped() {
        onDismissButtonTapped?()
    }
}
