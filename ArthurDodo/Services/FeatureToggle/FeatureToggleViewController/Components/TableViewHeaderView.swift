import UIKit

final class TableViewHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var nameLabel = AppLabel(type: .maxiTitle, text: "Название фичи", alignment: .center)
    private lazy var localStatusLabel = AppLabel(type: .maxiTitle, text: "Локальный статус", alignment: .center)
    private lazy var remoteStatusLabel = AppLabel(type: .maxiTitle, text: "Удаленный статус", alignment: .center)
    private lazy var separatorView = AppView(type: .separator)

    private lazy var contentStack = setupContentStack()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension TableViewHeaderView {
    func setupUI() {
        separatorView.backgroundColor = AppColors.buttonOrange

        backgroundColor = AppColors.backgroundGray
        addSubviews(contentStack)
        contentStack.setConstraints()
    }

    func setupContentStack() -> UIStackView {
       let labelsStack = AppStackView([nameLabel, localStatusLabel, remoteStatusLabel], axis: .horizontal, distribution: .fillEqually)
        let contentStack = AppStackView([labelsStack, separatorView], axis: .vertical, spacing: 10)
        return contentStack
    }
}
