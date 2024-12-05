import UIKit

final class MainHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var addressStackView = AddressStackView()
    private lazy var profileContainerView = ProfileMainHeaderView()
    private lazy var contentStackView = setupContentStack()

    // MARK: - Properties
    var onProfileButtonTapped: (() -> Void)?
    var onAddressTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        isUIVisible(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension MainHeaderView {
    // Обновление всех UI на вью
    func updateUI(_ address: String, _ coins: Int) {
        updateAddress(address)
        updateProfileCoins(coins)
    }

    // Обновляем название адреса (Дом, офис и тп)
    private func updateAddress(_ address: String) {
        addressStackView.updateAddress(address)
        isUIVisible(true)
    }

    // Обновляем кол-во монет на профиле
    private func updateProfileCoins(_ coins: Int) {
        profileContainerView.updateCoinsLabel(with: coins)
    }
}

// MARK: - Setup button actions
private extension MainHeaderView {
    func setupActions() {
        setupAddressStackAction()
        setupProfileContainerAction()
    }

    func setupAddressStackAction() {
        addressStackView.onAddressTapped = { [weak self] in
            self?.onAddressTapped?()
        }
    }

    func setupProfileContainerAction() {
        profileContainerView.onButtonTapped = { [weak self] in
            self?.onProfileButtonTapped?()
        }
    }
}

// MARK: - Setup UI
private extension MainHeaderView {
    func setupUI() {
        addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        contentStackViewLayout()
    }

    func contentStackViewLayout() {
        contentStackView.setConstraints(insets: UIEdgeInsets(top: 10, left: 20, bottom: 5, right: 20))
    }

    // Настраиваем стек, указываем, что нужно увеличить размер address, но не нужно увеличивать размер profile (это позволяет нам не вставлять туда лишний UIView для расстояния)
    func setupContentStack() -> UIStackView {
        let contentStackView = AppStackView([addressStackView, profileContainerView], axis: .horizontal, spacing: 10)
        addressStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        profileContainerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return contentStackView
    }
}

// MARK: - Supporting methods
private extension MainHeaderView {
    // Показываем или скрываем все UI элементы на вьюхе (нужно в процессе загрузки экрана)
    func isUIVisible(_ isVisible: Bool) {
        [addressStackView, profileContainerView].forEach { $0.isHidden = !isVisible }
    }
}
