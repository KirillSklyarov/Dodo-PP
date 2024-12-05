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

    // Делаем констреинты (если нужно учитываем safeArea, если все отступы равны, то указываем только allInset, если нужны указать разные отступы, то пишем insets)
    func setConstraints(isSafeArea: Bool = false, allInsets: CGFloat? = nil, insets: UIEdgeInsets = .zero) {
        guard let superview else { return }
        let topConstraints = isSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let bottomConstraints = isSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
        let appliedInset = (allInsets != nil) ? UIEdgeInsets(top: allInsets!, left: allInsets!, bottom: allInsets!, right: allInsets!) : insets

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: appliedInset.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -appliedInset.right),
            topAnchor.constraint(equalTo: topConstraints, constant: appliedInset.top),
            bottomAnchor.constraint(equalTo: bottomConstraints, constant: -appliedInset.bottom)
        ])
    }
}
