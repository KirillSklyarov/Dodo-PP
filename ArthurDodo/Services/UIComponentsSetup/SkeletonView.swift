import UIKit
import SkeletonView

final class SkeletonView: UIView {

    // MARK: - Properties
    private let viewHeight: CGFloat = 300

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
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        setupSkeleton()
    }

    func setupSkeleton() {
        isSkeletonable = true

        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topBottom)

        showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkClouds), animation: animation)
    }
}
