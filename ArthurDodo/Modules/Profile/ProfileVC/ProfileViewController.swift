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
    private var state: ScreenState = .loading
    private let storage: DataStorage

    private var personalData: User?

    var onShowChatAlert: (() -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onShowPersonalData: (() -> Void)?
    var onShowPromoVC: ((Promo) -> Void)?

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
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
        fetchData()
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
            onShowPromoVC?(specialOffer)
//            showSpecialOfferView(specialOffer)
        }
    }

    // Настройка действий header view (где 3 кнопки)
    func setupHeaderViewActions() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }

        headerView.onChatButtonTapped = { [weak self] in
            self?.onShowChatAlert?()
        }

        headerView.onProfileButtonTapped = { [weak self] in
            self?.onShowPersonalData?()
        }
    }
}

// MARK: - Fetch Data
private extension ProfileViewController { // Запрашиваем данные с сервера
    func fetchData() {
        fetchUserDataFromStorage()
        fetchPromoFromStorage()
        setState(view: .mission, state: .success) // Выставляю нижней вью правильное состояние (потом можно будет убрать)
    }

    // Запрашиваем персональные данные с сервера: додокоины, кол-во заказов, адреса
    func fetchUserDataFromStorage() {
        guard let personalData = storage.getUserData() else { print("Error: fetchUserDataFromStorage"); return }
        passPersonalDataToCollectionView(personalData)
        setState(view: .personalData, state: .success)
    }

    // Запрашиваем спецпредложения с сервера (раздел Акции), передаем данные на вью и выставляем состояние у вьюхи
    func fetchPromoFromStorage() {
        let promo = storage.getPromo()
        passPromoToCollectionView(promo)
        setState(view: .promo, state: .success)
    }
}

// MARK: - Supporting methods
private extension ProfileViewController {
    func passPersonalDataToCollectionView(_ personalData: User) {
        personalDataCollectionView.getPersonalData(personalData)
    }

    func passPersonalDataToTableView(_ personalData: User) {
        personalDataCollectionView.getPersonalData(personalData)
    }

    func passPromoToCollectionView(_ promo: [Promo]) {
        promoStackView.updateUI(promo)
    }

    func setState(view: ProfileView, state: ScreenState) {
        switch view {
        case .profile: self.state = state
        case .personalData: personalDataCollectionView.setState(state)
        case .promo: promoStackView.setState(state)
        case .mission: missionStackView.setState(state)
        }
    }
}
