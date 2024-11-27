import UIKit

final class InfoButton: UIButton {

    private let buttonSize: CGFloat = 24

    var onInfoButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        let image = UIImage(systemName: "info.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        setImage(image, for: .normal)
        addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func infoButtonTapped() {
        onInfoButtonTapped?()
    }
}

