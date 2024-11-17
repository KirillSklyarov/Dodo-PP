import UIKit
import SkeletonView

final class SkeletonView: UIView {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension SkeletonView {
    func setupUI() {
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        isSkeletonable = true

        showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkClouds))
    }
}
