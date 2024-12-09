import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProfileHeaderView()
    private lazy var personalDataCollectionView = CoinsOrdersCollectionView()
    private lazy var promoStackView = PromoStackView()
    private lazy var missionStackView = MissionStackView()
    private lazy var contentStackView = AppStackView([personalDataCollectionView, promoStackView, missionStackView], axis: .vertical, spacing: 10)
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    let presenter: ProfilePresenter

    // MARK: - Init
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup UI
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, scrollView)

        setupScrollView()

        setupLayout()
    }

    // Настраиваем скролл вью
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubviews(contentStackView)
    }

    // Настраиваем констреинты
    func setupLayout() {
        setupHeaderViewLayout()
        setupScrollViewLayout()
        setupContentStackViewLayout()
    }

    func setupHeaderViewLayout() {
        headerView.setLocalConstraints(isSafeArea: true, top: 10, left: 10, right: 10)
    }

    func setupScrollViewLayout() {
        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        scrollView.setLocalConstraints(isSafeArea: true, bottom: 10, left: 10, right: 10)
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints()
        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension ProfileViewController {
    func setupActions() {
        setupHeaderViewActions()
        setupSpecialOfferActions()
    }

    // Настройка действий секции Акции
    func setupSpecialOfferActions() {
        promoStackView.onPromoSelected = { [weak self] specialOffer in
            guard let self else { return }
            presenter.onShowPromoVC?(specialOffer)
        }
    }

    // Настройка действий header view (где 3 кнопки)
    func setupHeaderViewActions() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.presenter.onDismissButtonTapped?()
        }

        headerView.onChatButtonTapped = { [weak self] in
            self?.presenter.onShowChatAlert?()
        }

        headerView.onProfileButtonTapped = { [weak self] in
            self?.presenter.onShowPersonalData?()
        }
    }
}

// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func updatePersonalData(_ personalData: User) {
        personalDataCollectionView.getPersonalData(personalData)
    }

    func updatePromo(_ promo: [Promo]) {
        promoStackView.updateUI(promo)
    }

    func setState(view: ProfileView, state: ScreenState) {
        switch view {
        case .personalData: personalDataCollectionView.setState(state)
        case .promo: promoStackView.setState(state)
        case .mission: missionStackView.setState(state)
        }
    }
}
