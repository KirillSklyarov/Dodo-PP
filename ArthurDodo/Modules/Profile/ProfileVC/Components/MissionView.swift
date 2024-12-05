import UIKit

final class MissionView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .smallTitle, text: "Каждый месяц мы придумываем небольшие задания. Выполняйте их и получайте Dodo Coins. Это весело!", textColor: AppColors.grayFont)

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let bottomPadding: CGFloat = -10
    private let viewHeight: CGFloat = 250

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setupLayout()
        }
    }
}

// MARK: - Setup UI
private extension MissionView {
    func setupUI() {
        titleLabel.textAlignment = .center

        layer.cornerRadius = 14
        layer.masksToBounds = true

        backgroundColor = AppColors.backgroundGray

        addSubviews(titleLabel)

        setupContraints()
    }

    func setupContraints() {
        titleLabel.setLocalConstraints(bottom: 10, left: 10, right: 10)
    }

    func setupLayout() {
        guard let superview else { print("You must add superview to MissionView"); return }
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
    }
}
