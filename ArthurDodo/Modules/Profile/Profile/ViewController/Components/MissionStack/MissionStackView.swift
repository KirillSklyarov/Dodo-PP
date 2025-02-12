import UIKit
import AppUIComponentsSPM

final class MissionStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var headerLabel = AppLabel(type: .header, text: "Миссии")
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
        axis = .vertical
        spacing = 10

        configureUIElements()
    }

    // Убираем блендинг у UI элементов
    func configureUIElements() {
        headerLabel.isOpaque = true
        headerLabel.backgroundColor = AppColors.backgroundBlack
    }
}

// MARK: - State management
private extension MissionStackView {
    func showScreenWithState() {
        switch state {
        case .initial: break
        case .loading: showSkeleton()
        case .success: showSuccessScreen()
        case .error: break
        }
    }

    func showSkeleton() {
        addArrangedSubview(skeletonView)
        skeletonView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }

    func showSuccessScreen() {
        skeletonView.removeFromSuperview()
        [headerLabel, missionView].forEach { addArrangedSubview($0) }
    }
}
