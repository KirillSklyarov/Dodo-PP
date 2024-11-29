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

    func setConstraints(isSafeArea: Bool = false) {
        guard let superview else { return }
        let topConstraints = isSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let bottomConstraints = isSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: topConstraints),
            bottomAnchor.constraint(equalTo: bottomConstraints)
        ])
    }
}
