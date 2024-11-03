import UIKit
import SkeletonView

final class SkeletonPlaceholderCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier = String(describing: SkeletonPlaceholderCell.self)

    // MARK: - UI Properties
    private lazy var placeholderView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSkeleton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Skeleton
private extension SkeletonPlaceholderCell {
    func setupSkeleton() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        placeholderView.isSkeletonable = true
    }
}

// MARK: - Setup UI
private extension SkeletonPlaceholderCell {
    func setupUI() {
        contentView.addSubviews(placeholderView)

        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
