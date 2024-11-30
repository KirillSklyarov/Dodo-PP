import UIKit

final class CartViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .cart) // Заголовок с кнопкой
    private lazy var orderStackView = OrderStackView() // Хэдер и таблица с заказами
    private lazy var itemsToAddStackView = ItemsToAddStackView() // Добавки к заказу
    private lazy var promoStackView = PromoStackView() // Акции
    private lazy var enterPromoCodeButton = AppButtons(type: .promoButton) // Кнопка Ввести промокод
    private lazy var dodoCoinsView = DodoCoinsStackView() // Блок с додокоинами
    private lazy var cartButtonView = AppCartButtonView(type: .cart) // Кнопка корзины
    private lazy var scrollUpButton = AppButtons(type: .scrollUp) // Кнопка scrollToTop
    private lazy var contentStackView = AppStackView([orderStackView, itemsToAddStackView, promoStackView, enterPromoCodeButton, dodoCoinsView], axis: .vertical, spacing: 10)
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10

    private let storage: DataStorage

    private var state: ScreenState = .loading

    var onCartVCDismissed: (() -> Void)?
    var onShowEditProductVC: (() -> Void)?
    var onShowPromoVC: ((Promo) -> Void)?
    var onShowDeliveryVC: (() -> Void)?

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

    // Мы обновляем кнопку корзины на mainVC всегда, когда закрывается это окно (либо по свайпу, либо по нажатию на кнопку dismiss, либо по причине пустой корзины)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onCartVCDismissed?()
    }

    func updateCart() {
        fetchCart()
    }
}

// MARK: - Fetch Data
private extension CartViewController {
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }

            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            fetchCart() {
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            fetchItemsToAdd() {
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            fetchPromo() {
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.setState(.success)
            }
        }
    }

    // Получаем заказ с хранилища и передаем его в таблицу
    func fetchCart(completion: (() -> Void)? = nil) {
        guard let order = storage.getCartFromStorage() else { print("Cart not found in storage"); return }
        passCartToView(order)
        updateUI()
        completion?()
    }

    func updateUI() {
        let countOfItems = storage.getCountOfItemsInCart()
        let totalPrice = storage.getTotalCartPrice()
        updateOrderData(countOfItems, totalPrice)
        updateDodoCoinsView(countOfItems, totalPrice)
        updateCartButtonPrice(totalPrice)
    }

    // Сначала запрашиваем из хранилища (мб ранее уже загружались промо), если в хранилище нет, то запрашиваем с сервера, если есть, то обновляем UI
    func fetchPromo(completion: (() -> Void)? = nil) {
        let isPromoInStorage = storage.isPromoAlreadyFetched()

        if isPromoInStorage {
            getPromoFromStorage()
        } else {
            fetchPromoFromServer()
        }
        completion?()
    }

    // Получаем данные из хранилища и передаем их в коллекцию и выставляем состояние экрана
    func getPromoFromStorage() {
        let promo = storage.getPromoFromStorage()
        promoCollectionUpdateUI(promo)
        promoStackView.setState(.success)
    }

    // Передаем данные в коллекцию и обновляем ее
    func promoCollectionUpdateUI(_ promo: [Promo]) {
        promoStackView.updateUI(promo)
    }

    func fetchPromoFromServer() {
        storage.fetchPromo()
        storage.onPromoFetchedSuccessfully = { [weak self] fetchedPromo in
            guard let self else { return }
            promoCollectionUpdateUI(fetchedPromo)
            promoStackView.setState(.success)
        }
    }

    // Получаем товары, для отражения в корзине в категории "Добавить к заказу"
    func fetchItemsToAdd(completion: (() -> Void)? = nil) {
        let itemsToAdd = storage.getSpecialOffersArray()
        sendItemsToAdd(itemsToAdd)
        completion?()
    }

    // Отправляем товары для отражения в категории "Добавить к заказу" далее по вьюхе
    func sendItemsToAdd(_ items: [Item]) {
        itemsToAddStackView.getItemsToAdd(items)
        itemsToAddStackView.setState(.success)
    }

    // Отправляем актуальный заказ далее для отражения на след вьюхе
    func passCartToView(_ cart: Cart) {
        orderStackView.getCart(cart)
    }
}

// MARK: - Setup Actions
private extension CartViewController {
    func setupActions() {
        setupHeaderViewAction()
        setupCartProductTableViewAction()
        setupToppingsCollectionView()
        setupSpecialViewActions()
        setupScrollUpButtonAction()
        setupCartButtonAction()
    }

    func setupHeaderViewAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            onCartVCDismissed?()
        }
    }

    func setupCartProductTableViewAction() {
        orderStackView.onEmptyCart = { [weak self] in
            guard let self else { return }
            onCartVCDismissed?()
        }

        // Удаляем позицию из заказа и опять фетчим заказы
        orderStackView.onItemDeletedFromCart = { [weak self] indexPath in
            self?.storage.removeItemFromCart(indexPath)
            self?.fetchCart()
        }

        orderStackView.onCountChanged = { [weak self] indexPath, count in
            self?.storage.changeCountOfItems(indexPath, count)
            self?.fetchCart()
        }

        // Нажали на ячейку в таблице с товаром, отправили редактируемый товар в хранилище и открыли экран с этим товаром, при закрытии этого экрана срабатывает комплишн и мы заново загружаем корзину
        orderStackView.onItemCellSelected = { [weak self] item in
            guard let self else { return }
            storage.setChangingItem(item) //
            onShowEditProductVC?()
        }
    }

    func setupScrollUpButtonAction() {
        scrollUpButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            let topInset = scrollView.adjustedContentInset.top
            scrollView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: true)
        }
    }

    func setupSpecialViewActions() {
        promoStackView.onPromoSelected = { [weak self] specialOffer in
            guard let self else { print("We can't show promoVC"); return }
            onShowPromoVC?(specialOffer)
        }
    }

    func setupToppingsCollectionView() {
        itemsToAddStackView.onNewItemToAddToCart = { [weak self] itemToAddToOrder in
            guard let self else { return }
            storage.addItemToCart(item: itemToAddToOrder)
            fetchCart()
        }
    }

    func setupCartButtonAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            onShowDeliveryVC?()
        }
    }
}

// MARK: - Setup UI
private extension CartViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, scrollView, cartButtonView)

        setupScrollView()
        setupLayout()
    }

    func setupScrollView() {
        scrollView.addSubviews(contentStackView, scrollUpButton)
        scrollView.delegate = self
    }
}

// MARK: - Constraints
private extension CartViewController {
    func setupLayout() {
        setupHeaderViewLayout()
        setupScrollViewConstraints()
        setupContentStackViewConstraints()
        setupScrollUpButtonConstraints()
        setupCartButtonConstraints()
    }

    func setupHeaderViewLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor, constant: bottomInset)
        ])
    }

    func setupContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: rightInset * 2),
        ])
    }

    func setupScrollUpButtonConstraints() {
        NSLayoutConstraint.activate([
            scrollUpButton.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor, constant: bottomInset),
            scrollUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
        ])
    }

    func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UIScrollViewDelegate - настройка кнопки scrollToTop
extension CartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupScrollUpButtonAction(scrollView: scrollView)
    }

    // Определяет если прокрутили больше половины контента, по показать кнопку, если меньше - скрыть кнопку
    private func setupScrollUpButtonAction(scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let visibleHeight = scrollView.frame.height

        // Срабатывает когда по каким-то причинам контент еще не загрузился
        if contentHeight == 0 {
            scrollUpButton.isHidden = true
            return
        }

        // Срабатывает когда прокрутили больше половины контента
        if scrollOffset > (contentHeight - visibleHeight) / 2 {
            scrollUpButton.isHidden = false
        } else {
            scrollUpButton.isHidden = true
        }
    }
}

// MARK: - Supporting methods
private extension CartViewController {
    func updateDodoCoinsView(_ countOfItems: Int, _ totalPrice: Int) {
        let dodoCoins = totalPrice / 10
        dodoCoinsView.setCountOfItems(countOfItems)
        dodoCoinsView.setTotalPrice(totalPrice)
        dodoCoinsView.setDodoCoins(dodoCoins)
    }

    func updateOrderData(_ countOfItems: Int, _ totalPrice: Int) {
        orderStackView.updateHeader(countOfItems, totalPrice: totalPrice)
    }

    func updateCartButtonPrice(_ totalPrice: Int) {
        cartButtonView.updatePrice(totalPrice)
    }

    // Устанавливает состояние экрана
    private func setState(_ state: ScreenState) {
        self.state = state
    }
}
