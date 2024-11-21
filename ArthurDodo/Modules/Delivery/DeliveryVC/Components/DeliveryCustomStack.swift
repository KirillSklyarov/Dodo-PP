import UIKit

final class DeliveryCustomStackView: UIStackView {

    init(_ arrangedSubviews: UIView..., spacing: CGFloat = 10) {
        super.init(frame: .zero)
        setupUI(arrangedSubviews, spacing: spacing)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DeliveryCustomStackView {
    func setupUI(_ arrangedSubviews: [UIView], spacing: CGFloat) {
        arrangedSubviews.forEach { addArrangedSubview($0) }
        axis = .vertical
        self.spacing = spacing
    }
}
