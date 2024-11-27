import UIKit

final class MissionStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var headerLabel = AppLabelDS(type: .header, text: "Миссии")
    private lazy var missionView = MissionView()
    private lazy var skeletonView = CustomSkeletonViewBorder()

    // MARK: - Other properties
    private let cornerRadius: CGFloat = 10

    private var state: ScreenState = .loading

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        showScreenWithState()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension MissionStackView {
    func setState(_ state: ScreenState) {
        self.state = state
        showScreenWithState()
    }
}

// MARK: - Setup UI
private extension MissionStackView {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        axis = .vertical
        spacing = 10
    }
}

// MARK: - State management
private extension MissionStackView {
    func showScreenWithState() {
        switch state {
        case .loading: showSkeleton()
        case .success: showSuccessScreen()
        case .error: break
        }
    }

    func showSkeleton() {
        skeletonView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        addArrangedSubview(skeletonView)
    }

    func showSuccessScreen() {
        skeletonView.removeFromSuperview()
        addArrangedSubview(headerLabel)
        addArrangedSubview(missionView)
        missionView.setBorder()
    }
}
