import UIKit

final class AddNewAddressButton: UIButton {

    // MARK: - Properties
    private let buttonWidth: CGFloat = 150

    var onAddNewAddressButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AddNewAddressButton {
    func setup() {
        let title = "+ Новый адрес"
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle = AttributedString(title, attributes:
                                                    AttributeContainer([ .font: AppFonts.bold14]))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = AppColors.buttonGray
        config.cornerStyle = .capsule
        configuration = config
        addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
    }

    func setupLayout() {
        widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    }

    @objc func addAddressButtonTapped() {
        onAddNewAddressButtonTapped?()
    }
}
