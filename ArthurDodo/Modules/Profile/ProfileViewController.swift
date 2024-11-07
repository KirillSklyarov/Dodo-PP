import UIKit
import SkeletonView

final class ProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProfileHeaderView()
    private lazy var personalDataCollectionView = CoinsOrdersCollectionView(personalData: personalData)
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
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    private var personalData: Personal?
    private var isDataLoaded: Bool = false

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
    }

    // При каждом появлении экрана мы решаем нужно ли загружать данные из сети или просто забрать с сервера (делаем тут а не во viewDidLoad из-за скелетона, там он не работает)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromServerOrGetDataFromStorage()
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

    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubviews(contentStackView)
    }

    func setupLayout() {
        setupHeaderViewLayout()
        setupScrollViewLayout()
        setupContentStackViewLayout()
    }

    func setupHeaderViewLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
        ])
    }

    func setupScrollViewLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: topInset),
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

// MARK: - Supporting methods
private extension ProfileViewController {
    // Мы спрашиваем были ли ранее уже загружены данные и если нет, то загружаем, а если да - то просто забираем их с хранилища
    func fetchDataFromServerOrGetDataFromStorage() {
        let isDataLoaded = storage.isPersonalDataLoaded()
        if !isDataLoaded {
            showSkeleton()
            fetchData()
        } else {
            getDataFromStorage()
        }
    }
}

// MARK: - Setup Actions
private extension ProfileViewController {
    func setupActions() {
        setupHeaderViewActions()
        setupSpecialOfferActions()
    }

    func setupHeaderViewActions() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        headerView.onChatButtonTapped = { [weak self] in
            self?.showChatAlert()
        }

        headerView.onProfileButtonTapped = { [weak self] in
            self?.showPersonalVC()
        }
    }
}

// MARK: - Fetch Data
private extension ProfileViewController {
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            fetchPersonalData()
            fetchPromo()
        }
    }

    func fetchPersonalData() {
        storage.fetchPersonalData()
        storage.onPersonalDataFetchedSuccessfully = { [weak self] personalData in
            self?.personalData = personalData
            self?.personalDataCollectionView.updateUI(personalData)
        }
    }

    func fetchPromo() {
        storage.fetchPromo()
        storage.onPromoFetchedSuccessfully = { [weak self] promo in
            guard let self else { return }
            DispatchQueue.main.async {
                self.promoStackView.updateUI(promo)
                self.stopSkeleton()
            }
        }
    }

    func getDataFromStorage() {
        if let personalData = storage.getPersonalData() {
            personalDataCollectionView.updateUI(personalData)
        }
        let promo = storage.getPromoFromStorage()
        promoStackView.updateUI(promo)
    }
}

// MARK: - Setup router
private extension ProfileViewController {
    func showChatAlert() {
        router.showChatAlert()
    }

    func showPersonalVC() {
        router.showPersonalData()
    }

    func setupSpecialOfferActions() {
        promoStackView.onPromoSelected = { [weak self] specialOffer in
            guard let self else { return }
            router.showApplySpecialOffer(specialOffer)
        }
    }
}

// MARK: - Setup Skeleton
private extension ProfileViewController {
    func showSkeleton() {
        personalDataCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .belizeHole))
        promoStackView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .emerald))
        missionStackView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .greenSea))
    }

    func stopSkeleton() {
        promoStackView.hideSkeleton()
        missionStackView.hideSkeleton()
        personalDataCollectionView.hideSkeleton()
    }
}
