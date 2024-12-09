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
        getCartFromStorage()
    }
}

// MARK: - Fetch Data
private extension CartViewController {
    func fetchData() {
        getPromoFromStorage()
        getItemsToAddFromStorage()
        getCartFromStorage()
        setState(.success)
    }

    // Получаем заказ с хранилища и передаем его в таблицу
    func getCartFromStorage() {
        guard let order = storage.getCartFromStorage() else { print("Cart not found in storage"); return }
        passCartToView(order)
        updateUI()
    }

    func updateUI() {
        let countOfItems = storage.getCountOfItemsInCart()
        let totalPrice = storage.getTotalCartPrice()
        updateOrderData(countOfItems, totalPrice)
        updateDodoCoinsView(countOfItems, totalPrice)
        updateCartButtonPrice(totalPrice)
    }

    // Получаем данные из хранилища и передаем их в коллекцию и выставляем состояние экрана
    func getPromoFromStorage() {
        let promo = storage.profileStorage.getPromo()
        promoCollectionUpdateUI(promo)
        promoStackView.setState(.success)
    }

    // Передаем данные в коллекцию и обновляем ее
    func promoCollectionUpdateUI(_ promo: [Promo]) {
        promoStackView.updateUI(promo)
    }

    // Получаем товары, для отражения в корзине в категории "Добавить к заказу"
    func getItemsToAddFromStorage() {
        let itemsToAdd = storage.getSpecialOffersArray()
        sendItemsToAdd(itemsToAdd)
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
            self?.getCartFromStorage()
        }

        orderStackView.onCountChanged = { [weak self] indexPath, count in
            self?.storage.changeCountOfItems(indexPath, count)
            self?.getCartFromStorage()
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
            getCartFromStorage()
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
        headerView.setLocalConstraints(isSafeArea: true, top: 0, left: 0, right: 0)
    }

    func setupScrollViewConstraints() {
        scrollView.setLocalConstraints(left: 0, right: 0)
        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor, constant: -10).isActive = true
    }

    func setupContentStackViewConstraints() {
        contentStackView.setLocalConstraints(left: 10, right: 10)
        contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: (-10) * 2).isActive = true
    }

    func setupScrollUpButtonConstraints() {
        scrollUpButton.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor, constant: -10).isActive = true
        scrollUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }

    func setupCartButtonConstraints() {
        cartButtonView.setLocalConstraints(bottom: 0, left: 0, right: 0)
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
