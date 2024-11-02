import UIKit
import SkeletonView

final class MissionStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var missionHeaderView = OrderView(title: "Миссии")
    private lazy var missionView = MissionView()

    // MARK: - Other properties
    private let leftInset: CGFloat = 0
    private let rightInset: CGFloat = 0
    private let cornerRadius: CGFloat = 10

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSkeleton()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setupLayout()
        }
    }
}

// MARK: - Setup UI
private extension MissionStackView {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        addArrangedSubview(missionHeaderView)
        addArrangedSubview(missionView)
        axis = .vertical
        spacing = 10
        missionView.setBorder()
    }

    func setupLayout() {
        guard let superview else { print("You must add superview to MissionStackView"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftInset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightInset),
        ])
    }
}

// MARK: - Setup Skeleton
private extension MissionStackView {
    func setupSkeleton() {
        isSkeletonable = true
    }
}
