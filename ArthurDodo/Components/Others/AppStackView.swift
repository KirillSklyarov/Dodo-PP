import UIKit

final class AppStackView: UIStackView {

    init(_ arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, alignment: Alignment = .fill, distribution: Distribution = .fill) {
        super.init(frame: .zero)
        setupUI(arrangedSubviews, spacing: spacing, axis: axis, alignment: alignment, distribution: distribution)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppStackView {
    func setupUI(_ arrangedSubviews: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis, alignment: Alignment, distribution: Distribution) {
        arrangedSubviews.forEach { addArrangedSubview($0) }
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}
