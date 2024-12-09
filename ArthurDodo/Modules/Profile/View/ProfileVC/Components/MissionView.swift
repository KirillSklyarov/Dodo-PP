import UIKit

final class MissionView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .smallTitle, text: "Каждый месяц мы придумываем небольшие задания. Выполняйте их и получайте Dodo Coins. Это весело!", textColor: AppColors.grayFont, alignment: .center)

    // MARK: - Properties
    private let viewHeight: CGFloat = 250

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension MissionView {
    func setupUI() {
        titleLabel.numberOfLines = 0
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setBorder()

        addSubviews(titleLabel)

        setupContraints()
    }

    func setupContraints() {
        titleLabel.setLocalConstraints(bottom: 10, left: 10, right: 10)
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
    }
}
