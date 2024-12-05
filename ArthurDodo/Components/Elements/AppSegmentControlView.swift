import UIKit

// Здесь делается фон и на него накладывается сегментКонтрол
final class AppSegmentControlView: UIView {

    // MARK: - Properties&Callbacks
    private let viewHeight: CGFloat = 40
    private var segmentControl: CustomSegmentControl?

    var onSegmentControllerValueChanged: ((Int) -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, items: [Any]?, defaultSelection: Int) {
        super.init(frame: frame)
        segmentControl = CustomSegmentControl(items: items, defaultSelection: defaultSelection)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension AppSegmentControlView {
    func getSegmentControll() -> CustomSegmentControl? {
        segmentControl
    }

    func setDefaultSelectedSegment(_ index: Int) {
        segmentControl?.selectedSegmentIndex = index
    }

    func setSegmentColor(_ color: UIColor) {
        segmentControl?.setSegmentColor(color)
    }
}

// MARK: - Setup UI
private extension AppSegmentControlView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = viewHeight / 2
        clipsToBounds = true

        guard let segmentControl else { return }
        addSubviews(segmentControl)

        setupLayout()
    }

    func setupLayout() {
        segmentControl?.setConstraints(allInsets: 2)
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
    }
}

// MARK: - Setup Actions
private extension AppSegmentControlView {
     func setupActions() {
        segmentControl?.onSegmentControllerValueChanged = { [weak self] index in
            self?.onSegmentControllerValueChanged?(index)
        }
    }
}
