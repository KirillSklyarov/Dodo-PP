import UIKit

enum AppSegmentControlType {
    case address
    case size
    case dough
}

final class AppSegmentControl: UIView {

    // MARK: - Properties
    var segmentControl: CustomSegmentControl?

    var onSegmentValueChanged: ((Int) -> Void)?

    // MARK: - Init
    init(type: AppSegmentControlType) {
        super.init(frame: .zero)
        configure(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension AppSegmentControl {
    func setDefaultSelectedSegment(_ index: Int) {
        segmentControl?.selectedSegmentIndex = index
    }
}

private extension AppSegmentControl {
    func configure(type: AppSegmentControlType) {
        switch type {
        case .address:
            let segmentView = AppSegmentControlView(items: ["Доставка", "В пиццерии"], defaultSelection: 0)
            segmentControl = segmentView.getSegmentControll()
            segmentView.setSegmentColor(AppColors.buttonOrange)
            segmentView.backgroundColor = AppColors.backgroundBlack
            setLayout(segmentView)

            segmentView.onSegmentControllerValueChanged = { [weak self] value in
                self?.onSegmentValueChanged?(value)
            }
        case .size:
            let segmentView = AppSegmentControlView(items: AppConstants.sizeCases, defaultSelection: 1)
            segmentControl = segmentView.getSegmentControll()
            setLayout(segmentView)
        case .dough:
            let segmentView = AppSegmentControlView(items: AppConstants.doughCases, defaultSelection: 0)
            segmentControl = segmentView.getSegmentControll()
            setLayout(segmentView)
        }

    }
}

extension AppSegmentControl {
    func setLayout(_ segmentView: AppSegmentControlView) {
        addSubviews(segmentView)
        segmentView.setConstraints()
    }
}
