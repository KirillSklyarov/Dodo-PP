import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = HeaderView()
    private lazy var contentCollectionView = ContentCollectionView()
    private lazy var cartButton = CartButton(isHidden: true, isNeedImage: true)

    // MARK: - Other properties
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -20
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20

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
        fetchAllData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCart()
    }
}

// MARK: - Public methods
extension MainViewController {
    func updateCart() {
        let totalPrice = storage.getTotalOrderPrice()
        cartButton.updateCart(with: totalPrice)
    }

    func updateUI() {
        contentCollectionView.reloadData()
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        setupNavigationBar()

        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, contentCollectionView, cartButton)
        setupLayout()
    }

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: topInset),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomInset),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
        ])
    }
}

// MARK: - Setup Actions
private extension MainViewController {
    func setupActions() {
        setupCollectionView()
        setupHeaderView()
        setupCartButtonActions()
    }

    func setupCollectionView() {
        contentCollectionView.onItemCellTapped = { [weak self] IndexPath in
            guard let self else { return }
            let catalog = storage.getCatalog()
            let item = catalog[IndexPath.item]
            storage.fetchToppings()
            sendSelectedItemToStorage(item)
            showProductDetail()
        }

        contentCollectionView.onStoriesCellTapped = { [weak self] IndexPath in
            self?.showStoriesVC(IndexPath)
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            guard let self else { return }
            let specialOfferArray = storage.getSpecialOffersArray()
            let item = specialOfferArray[IndexPath.item]
            sendSelectedItemToStorage(item)
            showProductDetail()
        }
    }

    func setupHeaderView() {
        headerView.onProfileButtonTapped = { [weak self] in
            self?.showProfileVC()
        }

        headerView.onAddressTapped = { [weak self] in
            self?.showAddressVC()
        }
    }

    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            self?.showCartVC()
        }
    }

    func sendSelectedItemToStorage(_ item: Item) {
        storage.sendSelectedItemToStorage(item)
    }
}

// MARK: - Setup navigation
private extension MainViewController {
    func showProfileVC() {
        router.showProfileScreen()
    }

    func showProductDetail() {
        router.showProductDetailsScreen() { [weak self] in
            self?.updateCart()
        }
    }

    func showStoriesVC(_ indexPath: IndexPath) {
        router.showStories(indexPath) { [weak self] in
            self?.updateUI()
        }
    }

    func showAddressVC() {
        router.showAddress()
    }

    func showCartVC() {
        router.showCart { [weak self] in
            guard let self else { print("CartCoordinator is deallocated"); return }
            updateCart()
        }
    }
}

// MARK: - Fetch data from server
private extension MainViewController {
    func fetchAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.getStoriesFromServer()
            self?.getCatalogAndSpecialOffersFromServer()
        }
    }

    func getCategories() {
        let categories = storage.getCategories()
        passCategories(categories)
    }

    // Мы обращаемся к хранилищу за сторисами, инициируем сетевой запрос и забираем результаты
    func getStoriesFromServer() {
        storage.fetchStories()

        storage.onStoriesFetchedSuccessfully = { [weak self] stories in
            self?.passStoriesToContentCollectionView(stories)
        }
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromServer() {
        storage.fetchItems()

        storage.onItemsFetchedSuccessfully = { [weak self] items in
            guard let self else { return }
            getCategories()
            getSpecialOffers()
            getCatalogue()
            setState(.success)
        }
    }

    func getSpecialOffers() {
        let specialOffersArray = storage.getSpecialOffersArray()
        passSpecialOffersToContentCollectionView(specialOffersArray)
    }

    func getCatalogue() {
        let catalog = storage.getCatalog()
        passCatalogToContentCollectionView(catalog)
    }

    func setState(_ state: ScreenState) {
        self.state = state
        passStateToContentCollectionView(state)
    }
}

// MARK: - Supporting methods
private extension MainViewController {
    func passStateToContentCollectionView(_ state: ScreenState) {
        contentCollectionView.setState(state)
    }

    func passCategories(_ categories: [CategoryName]) {
        contentCollectionView.getCategories(categories)
    }

    func passStoriesToContentCollectionView(_ stories: [Story]) {
        contentCollectionView.getStories(stories)
    }

    func passSpecialOffersToContentCollectionView(_ specialOffers: [Item]) {
        contentCollectionView.getSpecialOffers(specialOffers)
    }

    func passCatalogToContentCollectionView(_ catalogue: [Item]) {
        contentCollectionView.getCatalog(catalogue)
    }
}
