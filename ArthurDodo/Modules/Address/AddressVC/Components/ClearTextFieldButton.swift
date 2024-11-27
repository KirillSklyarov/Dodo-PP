import UIKit

final class ClearTextFieldButton: UIButton {

    var onButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        let image = UIImage(systemName: "xmark.circle.fill")
        setImage(image, for: .normal)
        tintColor = AppColors.grayFont
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}
