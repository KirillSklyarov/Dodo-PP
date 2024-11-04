import UIKit
import SkeletonView

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

    private var isDataLoaded: Bool = false

    private let storage: DataStorage
    weak var coordinator: MainCoordinator?

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
        fetchAllData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        cartButton.updateCart()

        if !isDataLoaded { showSkeleton() }
    }
}

// MARK: - Public methods
extension MainViewController {
    func updateCart() {
        cartButton.updateCart()
    }

    func updateUI() {
        contentCollectionView.reloadData()
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
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
        coordinator?.showProfile()
    }

    func showProductDetail() {
        coordinator?.showProductDetails()
    }

    func showStoriesVC(_ indexPath: IndexPath) {
        coordinator?.showStories(indexPath)
    }

    func showAddressVC() {
        coordinator?.showAddress()
    }

    func showCartVC() {
        coordinator?.showCart()
    }
}

// MARK: - Fetch data from server
private extension MainViewController {
    func fetchAllData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.getStoriesFromServer()
            self?.getCatalogAndSpecialOffersFromServer()
        }
    }

    // Мы обращаемся к хранилищу за сторисами, инициируем сетевой запрос и забираем результаты
    func getStoriesFromServer() {
        storage.fetchStories()
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromServer() {
        storage.fetchItems()

        storage.onItemsFetchedSuccessfully = { [weak self] items in
            guard let self else { return }
            updateSpecialOffersUI()
            isDataLoaded = true
        }
    }

    // Вызываем обновление UI всех секций
    func updateSpecialOffersUI() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.uploadDataFromStorage()
        }
    }
}

// MARK: - Setup Skeleton
private extension MainViewController {
    func showSkeleton() {
        contentCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .alizarin))
    }

    func stopSkeleton() {
        DispatchQueue.main.async {
            self.contentCollectionView.stopSkeletonAnimation()
            self.contentCollectionView.hideSkeleton()
        }
    }
}
