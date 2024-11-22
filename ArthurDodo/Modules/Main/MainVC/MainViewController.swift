import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = HeaderView() // Заголовок с кнопками
    private lazy var orderView = OrderMainVCView() // Вью с заказом (или скрыто или показывается)
    private lazy var contentCollectionView = ContentCollectionView() // Основная коллекция с товарами
    private lazy var cartButton = CartButton(isHidden: true, isNeedImage: true) // Кнопка корзины

    // MARK: - Other properties
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -20
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20

    private var state: ScreenState = .loading

    private let storage: DataStorage

    var onProfileButtonTapped: (() -> Void)?
    var onAddressButtonTapped: (() -> Void)?
    var onStoryTapped: ((IndexPath) -> Void)?
    var onProductDetailsTapped: (() -> Void)?
    var onCartButtonTapped: (() -> Void)?

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

    // Каждый раз когда появляется экран мы обновляем статус корзины, чтобы понять показывать ее или нет
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCart()
    }
}

// MARK: - Public methods
extension MainViewController {
    // Обновление коллекции
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadData()
        }
    }

    func updateStories() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    // При каждом показе экрана мы запрашиваем актуальную корзину и если там есть позиции, то обновляем сумму на кнопке
    func updateCart() {
        let totalPrice = storage.getTotalCartPrice()
        cartButton.updateCart(with: totalPrice)
    }

    // Показать или не показать вью с заказом
    func isNeedToShowOrderView() {
        let isActiveOrder = UserDefaults.standard.getIsActiveOrder() // Проверяет у UserDefaults есть ли активный заказ

        // Только если заказ есть, то пересылаем данные во вью
        if isActiveOrder { passOrderToView() }

        updateUI(isActiveOrder)
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        setupNavigationBar()

        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, orderView, contentCollectionView, cartButton)
        setupLayout()

        isNeedToShowOrderView()
    }

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Setup layout
private extension MainViewController {
    func setupLayout() {
        setupHeaderViewLayout()
        setupOrderViewLayout()
        setupContentCollectionViewLayout()
        setupCartButtonLayout()
    }

    func setupHeaderViewLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupOrderViewLayout() {
        NSLayoutConstraint.activate([
            orderView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            orderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupContentCollectionViewLayout() {
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: orderView.bottomAnchor, constant: topInset),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupCartButtonLayout() {
        NSLayoutConstraint.activate([
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
            onProductDetailsTapped?()
        }

        contentCollectionView.onStoriesCellTapped = { [weak self] IndexPath in
            self?.onStoryTapped?(IndexPath)
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            guard let self else { return }
            let specialOfferArray = storage.getSpecialOffersArray()
            let item = specialOfferArray[IndexPath.item]
            sendSelectedItemToStorage(item)
            onProductDetailsTapped?()
        }
    }

    func setupHeaderView() {
        headerView.onProfileButtonTapped = { [weak self] in
            self?.onProfileButtonTapped?()
        }

        headerView.onAddressTapped = { [weak self] in
            self?.onAddressButtonTapped?()
        }
    }

    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            self?.onCartButtonTapped?()
        }
    }

    func sendSelectedItemToStorage(_ item: Item) {
        storage.sendSelectedItemToStorage(item)
    }
}

// MARK: - Fetch data from server
private extension MainViewController {
    // Обращаемся к хранилищу за необходимыми данными
    func fetchData() {
        getMainAddressFromStorage()
        getStoriesFromServer()
        getCatalogAndSpecialOffersFromServer()
    }

    // Так как у нас адреса лежат в личных данных, то проверяем если данные НЕ были ранее загружены, то инициируем сетевой запрос и обновляем header, а если данные уже есть, то забираем данные с сервера
    func getMainAddressFromStorage() {
        if storage.isAddressesEmpty() {
            fetchDataFromServer()
        } else {
            getDataFromStorageAndUpdateUI()
        }
    }

    // Делаем сетевой запрос и потом забираем данные с хранилища
    func fetchDataFromServer() {
        storage.fetchUserAddresses()
        storage.onDataFetchedSuccessfully = { [weak self] in
            guard let self else { return }
            getDataFromStorageAndUpdateUI()
        }
    }

    // Забираем данные из хранилища
    func getDataFromStorageAndUpdateUI() {
        guard let mainAddress = storage.getMainAddress() else { return }
        let addressName = mainAddress.name
        headerView.updateAddress(addressName)
    }

    // Мы обращаемся к хранилищу за сторисами, инициируем сетевой запрос, забираем результаты и передаем их в коллекцию
    func getStoriesFromServer() {
        storage.fetchStories()

        storage.onStoriesFetchedSuccessfully = { [weak self] stories in
            self?.passStoriesToContentCollectionView(stories)
        }
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromServer() {
        storage.fetchItems()

        storage.onItemsFetchedSuccessfully = { [weak self] in
            guard let self else { return }
            getCategories()
            getSpecialOffers()
            getCatalog()
            setState(.success)
        }
    }

    // Получаем категории и передаем в коллекцию
    func getCategories() {
        let categories = storage.getCategories()
        passCategoriesToContentCollectionView(categories)
    }

    // Получаем спецпредложения и передаем в коллекцию
    func getSpecialOffers() {
        let specialOffersArray = storage.getSpecialOffersArray()
        passSpecialOffersToContentCollectionView(specialOffersArray)
    }

    // Получаем каталог и передаем в коллекцию
    func getCatalog() {
        let catalog = storage.getCatalog()
        passCatalogToContentCollectionView(catalog)
    }

    // Получаем состояние и передаем в коллекцию
    func setState(_ state: ScreenState) {
        self.state = state
        setStateOnContentCollectionView(state)
    }
}

// MARK: - Supporting methods
private extension MainViewController {
    // Передает состояние в contentCollectionView
    func setStateOnContentCollectionView(_ state: ScreenState) {
        contentCollectionView.setState(state)
    }

    // Передает категории в contentCollectionView
    func passCategoriesToContentCollectionView(_ categories: [Category]) {
        contentCollectionView.getCategories(categories)
    }

    // Передает сторис в contentCollectionView
    func passStoriesToContentCollectionView(_ stories: [Story]) {
        contentCollectionView.getStories(stories)
    }

    // Передает спецпредложения в contentCollectionView
    func passSpecialOffersToContentCollectionView(_ specialOffers: [Item]) {
        contentCollectionView.getSpecialOffers(specialOffers)
    }

    // Передает каталог в contentCollectionView
    func passCatalogToContentCollectionView(_ catalogue: [Item]) {
        contentCollectionView.getCatalog(catalogue)
    }

    // Либо показывает orderView, либо не показывает (выставляет высоту 0)
    func updateUI(_ isActiveOrder: Bool) {
        orderView.calculateHeight(isActiveOrder)
    }

    func passOrderToView() {
        guard let order = storage.getOrderFromStorage() else { print("We have no order in storage"); return }
        let totalPrice = storage.getTotalOrderPrice()
        orderView.getOrder(order, totalPrice)
    }

    func showIsActiveOrder() {
        let isActiveOrder = UserDefaults.standard.getIsActiveOrder()
        print("isActiveOrder \(isActiveOrder)")
    }
}
