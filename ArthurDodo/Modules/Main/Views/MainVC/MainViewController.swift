import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = MainHeaderView() // Заголовок с кнопками
    private lazy var orderView = OrderMainVCView() // Вью с заказом (или скрыто или показывается)
    private lazy var contentCollectionView = ContentCollectionView() // Основная коллекция с товарами
    private lazy var cartButton = AppButtons(type: .cartMain) // Кнопка корзины

    private lazy var contentStackView = AppStackView([headerView, orderView, contentCollectionView], axis: .vertical, spacing: 5)

    // MARK: - Other properties
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
        let isActiveOrder = UserDefaults.standard.isActiveOrder() // Проверяет у UserDefaults есть ли активный заказ

        // Только если заказ есть, то пересылаем данные во вью
        if isActiveOrder { passOrderToView() }

        updateUI(isActiveOrder)
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView, cartButton)
        setupLayout()

        isNeedToShowOrderView()
    }
}

// MARK: - Setup layout
private extension MainViewController {
    func setupLayout() {
        setupContentStackViewLayout()
        setupCartButtonLayout()
    }

    // Настраиваем расположение стека с контентом
    func setupContentStackViewLayout() {
        contentStackView.setConstraints(isSafeArea: true)
    }

    // Настраиваем расположение кнопки
    func setupCartButtonLayout() {
        cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
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
        getStoriesFromStorage()
        getCatalogAndSpecialOffersFromStorage()
    }

    // Забираем данные из хранилища
    func getMainAddressFromStorage() {
        guard let mainAddress = storage.getMainAddress() else { print("Error: mainAddress is nil"); return }
        let addressName = mainAddress.name
        let userDodoCoins = storage.profileStorage.getDodoCoins()
        headerView.updateUI(addressName, userDodoCoins)
    }

    // Мы обращаемся к хранилищу за сторисами, инициируем сетевой запрос, забираем результаты и передаем их в коллекцию
    func getStoriesFromStorage() {
        let stories = storage.getFetchedStories()
        passStoriesToContentCollectionView(stories)
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromStorage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
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
        let isActiveOrder = UserDefaults.standard.isActiveOrder()
        print("isActiveOrder \(isActiveOrder)")
    }
}
