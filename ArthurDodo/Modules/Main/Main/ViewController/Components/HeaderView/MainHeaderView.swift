import UIKit
import AppUIComponentsSPM
import SkeletonView

final class MainHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var addressStackView = AddressStackView()
    private lazy var profileContainerView = ProfileMainHeaderView()
    private lazy var contentStackView = AppStackView([addressStackView, profileContainerView], axis: .horizontal, spacing: 10)

    // MARK: - Properties
    var onProfileButtonTapped: (() -> Void)?
    var onAddressTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()

        setState(.initial)
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

    // Показываем или скрываем фичу с профилем (зависит от featureToggle)
    func showProfileFeature(_ isVisible: Bool) {
        profileContainerView.isHidden = !isVisible
    }

    // Управление состояниями
    func setState(_ state: ScreenState) {
        switch state {
        case .initial: isUIVisible(false)
        case .loading: showSkeleton()
        case .success: hideSkeletonView()
        case .error: break
        }
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

        setupSkeleton()
    }

    func setupLayout() {
        contentStackViewLayout()
    }

    func contentStackViewLayout() {
        contentStackView.setConstraints(insets: UIEdgeInsets(top: 10, left: 20, bottom: 5, right: 20))
    }
}

// MARK: - Setup skeleton
private extension MainHeaderView {
    func setupSkeleton() {
        isSkeletonable = true
        skeletonCornerRadius = 10
    }

    func showSkeleton() {
        showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .darkClouds))
    }

    func hideSkeletonView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.hideSkeleton()
            self?.isUIVisible(true)
        }
    }
}

// MARK: - Supporting methods
private extension MainHeaderView {
    // Показываем или скрываем все UI элементы на вьюхе (нужно в процессе загрузки экрана)
    func isUIVisible(_ isVisible: Bool) {
        contentStackView.alpha = isVisible ? 1 : 0
    }

    // Обновляем название адреса (Дом, офис и тп)
    func updateAddress(_ address: String) {
        addressStackView.updateAddress(address)
    }

    // Обновляем кол-во монет на профиле
    func updateProfileCoins(_ coins: Int) {
        profileContainerView.updateCoinsLabel(with: coins)
    }
}
