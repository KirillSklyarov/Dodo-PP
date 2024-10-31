import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = HeaderView()
    private lazy var contentCollectionView = ContentCollectionView()
    private lazy var cartButton = CartButton(isHidden: true, isNeedImage: true)
    private lazy var loadingIndicator = AppLoadingIndicator()

    // MARK: - Other properties
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -20
    
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20

    private let storage: DataStorage
    private var router: Router?

    // MARK: - Init
    init(storage: DataStorage = DataStorage.shared) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
        self.router = Router(baseVC: self)
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
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, contentCollectionView, cartButton, loadingIndicator)
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

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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

    func showProfileVC() {
        router?.navigate(to: .profile)
    }

    func sendSelectedItemToStorage(_ item: Item) {
        storage.sendSelectedItemToStorage(item)
    }

    func showProductDetail() {
        router?.navigate(to: .productDetails) { [weak self] productDetailVC in
            guard let productDetailVC = productDetailVC as? ProductDetailsViewController else {
                print("Can't cast view controller to ProductDetailsViewController")
                return
            }

            productDetailVC.onCartButtonTapped = { [weak self] in
                guard let self else { print("Self is nil, can't set price"); return }
                cartButton.updateCart()
            }
        }
    }

    func showStoriesVC(_ indexPath: IndexPath) {
        router?.navigate(to: .stories) { [weak self] storiesVC in
            guard let storiesVC = storiesVC as? StoriesVC else {
                print("Can't cast view controller to StoriesViewController")
                return
            }
            storiesVC.showStories(indexPath)

            storiesVC.onStoriesVCDismissed = { [weak self] in
                self?.contentCollectionView.reloadData()
            }
        }
    }

    func showAddressVC() {
        router?.navigate(to: .address)
    }

    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            self?.showCartVC()
        }
    }

    func showCartVC() {
        router?.navigate(to: .cart) { [weak self] cartVC in
            guard let self else { return }
            guard let cartVC = cartVC as? CartViewController else {
                print("Can't cast view controller to CartViewController"); return }
            cartVC.onCartVCDismissed = {
                self.cartButton.updateCart()
            }
        }
    }
}

// MARK: - Fetch data from server
private extension MainViewController {
    func fetchAllData() {
        loadingIndicator.showLoadingIndicator()
        getStoriesFromServer()
        getCatalogAndSpecialOffersFromServer()
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
            DispatchQueue.main.async {
                self.updateSpecialOffersUI()
                self.loadingIndicator.hideLoadingIndicator()
            }
        }
    }

    // Вызываем обновление UI всех секций
    func updateSpecialOffersUI() {
        contentCollectionView.uploadDataFromStorage()
    }
}
