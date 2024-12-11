import UIKit

protocol CartViewProtocol: AnyObject {
    func setState(_ state: ScreenState)
    func updateUI(_ countOfItems: Int, _ totalPrice: Int)
    func promoCollectionUpdateUI(_ promo: [Promo])
    func updateCart(_ cart: Cart)
    func updateItemsToAdd(_ items: [Item])
}

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
    private lazy var scrollView = setupScrollView()

    private lazy var contentStack = AppStackView([headerView, scrollView, cartButtonView], axis: .vertical)

    // MARK: - Presenter
    let presenter: CartPresenterProtocol

    // MARK: - Init
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
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
        presenter.viewDidLoad()
    }

    // Мы обновляем кнопку корзины на mainVC всегда, когда закрывается это окно (либо по свайпу, либо по нажатию на кнопку dismiss, либо по причине пустой корзины)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.cartVCDismissed()
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
            presenter.cartVCDismissed()
        }
    }

    func setupCartProductTableViewAction() {
        orderStackView.onEmptyCart = { [weak self] in
            guard let self else { return }
            presenter.cartIsEmpty()
        }

        // Удаляем позицию из заказа и опять фетчим заказы
        orderStackView.onItemDeletedFromCart = { [weak self] indexPath in
            self?.presenter.deleteItemFromCart(indexPath)
        }

        // Изменяем кол-во единиц товара в корзине
        orderStackView.onCountChanged = { [weak self] indexPath, count in
            self?.presenter.changeCountOfItem(indexPath, count)
        }

        // Нажали на ячейку в таблице с товаром, отправили редактируемый товар в хранилище и открыли экран с этим товаром, при закрытии этого экрана срабатывает комплишн и мы заново загружаем корзину
        orderStackView.onItemCellSelected = { [weak self] item in
            self?.presenter.selectItem(item)
        }
    }

    // При нажатии на кнопку двигает скролл на самый верх
    func setupScrollUpButtonAction() {
        scrollUpButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            scrollToTop()

        }
    }

    func setupSpecialViewActions() {
        promoStackView.onPromoSelected = { [weak self] promo in
            guard let self else { print("We can't show promoVC"); return }
            presenter.promoSelected(promo)
        }
    }

    // Добавляем новую позицию в заказ
    func setupToppingsCollectionView() {
        itemsToAddStackView.onNewItemToAddToCart = { [weak self] itemToAddToOrder in
            guard let self else { return }
            presenter.addNewItemToCartTapped(itemToAddToOrder)

        }
    }

    func setupCartButtonAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            self?.presenter.cartButtonTapped()
        }
    }
}

// MARK: - Setup UI
private extension CartViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack)
        setupLayout()
    }

    // Настраиваем скролл вью
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.addSubviews(contentStackView, scrollUpButton)
        scrollView.delegate = self
        return scrollView
    }

    // Настраиваем констреинты
    func setupLayout() {
        setupContentStackLayout()
        setupContentStackViewLayout()
        setupScrollUpButtonLayout()
    }

    func setupContentStackLayout() {
        contentStack.setLocalConstraints(isSafeArea: true, top: 0, left: 0, right: 0)
        contentStack.setLocalConstraints(isSafeArea: false, bottom: 0)
    }

    func setupContentStackViewLayout() {
        contentStackView.setLocalConstraints(top: 0, bottom: 0, left: 10, right: 10)
        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: (-10) * 2).isActive = true
    }

    func setupScrollUpButtonLayout() {
        scrollUpButton.setLocalConstraints(left: 10)
        scrollUpButton.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor, constant: -10).isActive = true
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

        // Эта булевая переменная говорит что прокрутили больше половины контента
        let isScrollMoreThanHalfContentHeight = scrollOffset > (contentHeight - visibleHeight) / 2

        // Показываем кнопку если переменная true или скрываем если false
        scrollUpButton.isHidden = isScrollMoreThanHalfContentHeight ? false : true
    }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
    func setState(_ state: ScreenState) {
        promoStackView.setState(state)
    }

    func updateUI(_ countOfItems: Int, _ totalPrice: Int) {
        updateOrderData(countOfItems, totalPrice)
        updateDodoCoinsView(countOfItems, totalPrice)
        updateCartButtonPrice(totalPrice)
    }

    // Передаем данные в коллекцию и обновляем ее
    func promoCollectionUpdateUI(_ promo: [Promo]) {
        promoStackView.updateUI(promo)
    }

    // Передаем данные в коллекцию (товары для отражения в категории "Добавить к заказу")
    func updateItemsToAdd(_ items: [Item]) {
        itemsToAddStackView.getItemsToAdd(items)
        itemsToAddStackView.setState(.success)
    }

    // Передаем данные о корзине для отражения на view
    func updateCart(_ cart: Cart) {
        orderStackView.getCart(cart)
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

    func scrollToTop() {
        let topInset = scrollView.adjustedContentInset.top
        scrollView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: true)
    }
}
