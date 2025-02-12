import UIKit
import AppUIComponentsSPM

final class MissionView: UIView {

    // MARK: - UI Properties
    private lazy var containerView = DrawView(cornerRadius: .fourTeen)

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
        addSubviews(containerView)
        setupContainerView()

        setupContraints()

        configureUIElements()
    }

    // Настраиваем контейнер view - так мы избавляемся от блендинга
    func setupContainerView() {
        containerView.backgroundColor = AppColors.backgroundGray
        containerView.addSubviews(titleLabel)
    }

    // Убираем блендинг у UI элементов
    func configureUIElements() {
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = AppColors.backgroundGray
    }

    func setupContraints() {
        containerView.setConstraints()

        titleLabel.setLocalConstraints(bottom: 10, left: 10, right: 10)
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
    }
}
