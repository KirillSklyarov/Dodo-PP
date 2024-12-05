import UIKit

// Хэдер с сегмент контроллерами (доставки или в пиццерии) и кнопкой закрытия на экране карты
final class AddressHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .standard)
    private lazy var segmentControl = AppSegmentControl(type: .address)

    private lazy var contentStack = AppStackView([dismissButton, segmentControl], axis: .horizontal, spacing: 20)

    // MARK: - Properties
    var onDismissButtonTapped: (() -> Void)?
    var onDeliveryButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
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
private extension AddressHeaderView {
    func setupUI() {
        addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints()
    }
}

// MARK: - Setup Actions
private extension AddressHeaderView {
    func setupActions() {
        setupDismissButtonAction()
        setupSegmentControlAction()
    }

    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }

    func setupSegmentControlAction() {
        segmentControl.onSegmentValueChanged = { [weak self] segmentControlIndex in
            switch segmentControlIndex {
            case 0: self?.onDeliveryButtonTapped?()
            case 1: print(#function)
            default: break
            }
        }
    }
}
