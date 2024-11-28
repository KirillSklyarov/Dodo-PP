import UIKit

final class AddressHeaderView: UIStackView {

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView()
    private lazy var segmentControl = AppSegmentControlDS(type: .address)

    // MARK: - Properties
    private let leftPadding: CGFloat = 20
    private let rightPadding: CGFloat = -20
    private let topPadding: CGFloat = 10

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
        axis = .horizontal
        spacing = 20
        addArrangedSubview(dismissButton)
        addArrangedSubview(segmentControl)
    }

    func setupLayout() {
        guard let superview else { print("You must add AddressHeaderView to a superview"); return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding)
        ])
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
