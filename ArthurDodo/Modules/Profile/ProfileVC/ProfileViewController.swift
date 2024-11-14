import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var personalDataCollectionView = CoinsOrdersCollectionView()
    private lazy var promoStackView = PromoStackView()
    private lazy var missionStackView = MissionStackView()
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [personalDataCollectionView, promoStackView, missionStackView])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let topInset: CGFloat = 10

    private var state: ScreenState = .loading

    private let storage: DataStorage
    private let router: Router

    // MARK: - Init
    init(storage: DataStorage, router: Router) {
        self.storage = storage
        self.router = router
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
        setupNavigationBar()

        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(scrollView)

        setupScrollView()

        setupLayout()
    }

    // Настраиваем скролл вью
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubviews(contentStackView)
    }

    func setupLayout() {
        setupScrollViewLayout()
        setupContentStackViewLayout()
    }

    func setupScrollViewLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupContentStackViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}

// MARK: - Setup navigation bar
private extension ProfileViewController {
    func setupNavigationBar() {
        let dismissButtonView = DismissButtonView()
        let chatButtonView = ProfileButtonView(type: .chat)
        let profileButtonView = ProfileButtonView(type: .profile)

        navigationController?.isNavigationBarHidden = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButtonView)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: profileButtonView),
            UIBarButtonItem(customView: chatButtonView)
        ]
        
        setupNavigationViewActions(dismissButtonView, chatButtonView, profileButtonView)
    }
}

// MARK: - Setup Actions
private extension ProfileViewController {
    func setupActions() {
        setupSpecialOfferActions()
    }

    // Настройка действий секции Акции
    func setupSpecialOfferActions() {
        promoStackView.onPromoSelected = { [weak self] specialOffer in
            guard let self else { return }
            showSpecialOfferView(specialOffer)
        }
    }

    // Настройка действий навигации
    func setupNavigationViewActions(_ dismissButtonView: DismissButtonView, _ chatButtonView: ProfileButtonView, _ profileButtonView: ProfileButtonView) {

        dismissButtonView.onButtonTapped = { [weak self] in
            self?.dismissVC()
        }

        chatButtonView.onButtonTapped = { [weak self] in
            self?.showChatAlert()
        }

        profileButtonView.onButtonTapped = { [weak self] in
            self?.showPersonalVC()
        }
    }
}

// MARK: - Fetch Data
private extension ProfileViewController { // Запрашиваем данные с сервера
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }

            let dispatchGroup = DispatchGroup() // Решаем задачу вызвать setState только после завершения двух методов: fetchPersonalData, fetchPromo. Сначала делаем группу.

            // Входим в группу и выполняем метод, когда метод выполнен, вызывается комплишн и покидаем группу
            dispatchGroup.enter()
            fetchPersonalData {
                dispatchGroup.leave()
            }

            // Входим в группу и выполняем метод, когда метод выполнен, вызывается комплишн и покидаем группу
            dispatchGroup.enter()
            fetchPromo {
                dispatchGroup.leave()
            }

            // Группа сообщает, что все операции внутри нее выполнены и можно выполнять операции в теле setState, missionStackView.setState
            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self else { return }
                self.setState(view: .profile, state: .success)
                self.setState(view: .mission, state: .success)
            }
        }
    }

    // Запрашиваем персональные данные с сервера: додокоины, кол-во заказов, адреса
    func fetchPersonalData(completion: @escaping (() -> Void)) {
        storage.fetchPersonalData()
        storage.onPersonalDataFetchedSuccessfully = { [weak self] personalData in
            guard let self else { return }
            passPersonalDataToCollectionView(personalData)
            setState(view: .personalData, state: .success)
            completion()
        }
    }

    // Запрашиваем спецпредложения с сервера (раздел Акции)
    func fetchPromo(completion: @escaping (() -> Void)) {
        storage.fetchPromo()
        storage.onPromoFetchedSuccessfully = { [weak self] promo in
            guard let self else { return }
            passPromoToCollectionView(promo)
            setState(view: .promo, state: .success)
            completion()
        }
    }
}

// MARK: - Setup router
private extension ProfileViewController { // Здесь все переходы между экранами
    func showChatAlert() {
        router.showChatAlert()
    }

    func showPersonalVC() {
        router.showPersonalData()
    }

    func showSpecialOfferView(_ specialOffer: Promo) {
        router.showApplySpecialOffer(specialOffer)
    }

    func dismissVC() {
        router.dismissCurrentVC()
    }
}

// MARK: - Supporting methods
private extension ProfileViewController {
    func passPersonalDataToCollectionView(_ personalData: Personal) {
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
