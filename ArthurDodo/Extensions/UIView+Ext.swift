import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setBorder(_ color: UIColor = .white, borderWidth: CGFloat = 2) {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }

    // Делаем констреинты (если нужно учитываем safeArea, учитываем отступы)
    func setConstraints(isSafeArea: Bool = false, insets: UIEdgeInsets = .zero) {
        guard let superview else { return }
        let topConstraints = isSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let bottomConstraints = isSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: topConstraints, constant: insets.top),
            bottomAnchor.constraint(equalTo: bottomConstraints, constant: -insets.bottom)
        ])
    }
}
