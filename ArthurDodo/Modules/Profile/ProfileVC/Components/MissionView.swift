import UIKit

final class MissionView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(text: "Каждый месяц мы придумываем небольшие задания. Выполняйте их и получайте Dodo Coins. Это весело!", textColor: .grayFont, font: .semibold(size: 14), alignment: .center)

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
        layer.cornerRadius = 14
        layer.masksToBounds = true

        backgroundColor = AppColors.backgroundGray

        addSubviews(titleLabel)

        setupContraints()
    }

    func setupContraints() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding)
        ])
    }

    func setupLayout() {
        guard let superview else { print("You must add superview to MissionView"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),

            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}
