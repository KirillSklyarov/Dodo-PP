import UIKit

final class PencilButton: UIButton {

    private let buttonSize: CGFloat = 24

    var onButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        let image = UIImage(systemName: "pencil")?.withTintColor(AppColors.buttonGray, renderingMode: .alwaysOriginal)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        setImage(image, for: .normal)
        self.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}

