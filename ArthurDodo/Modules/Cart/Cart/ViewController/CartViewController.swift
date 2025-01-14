import UIKit

protocol CartViewControllerInput: BaseViewControllerInput where inputData == CartData {

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

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Presenter
    let output: any CartViewControllerOutput

    // MARK: - Init
    init(output: any CartViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("CartViewController deinit")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }

    // Мы обновляем кнопку корзины на mainVC всегда, когда закрывается это окно (либо по свайпу, либо по нажатию на кнопку dismiss, либо по причине пустой корзины)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.sendAction(.dismissButtonTapped)
    }
}

// MARK: - CartViewControllerInput
extension CartViewController: CartViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    func showLoading() {
        isShowContent(false)
        activityIndicator.startAnimating()
    }

    func configure(with data: CartData) {
        activityIndicator.stopAnimating()
        updateUIWithData(with: data)
        isShowContent(true)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Setup UI
private extension CartViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack, activityIndicator)
        setupLayout()
    }

    // Настраиваем констреинты
    func setupLayout() {
        setupContentStackLayout()
        setupContentStackViewLayout()
        setupScrollUpButtonLayout()
        setupActivityIndicator()
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

    // Настраиваем скролл вью
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.addSubviews(contentStackView, scrollUpButton)
        scrollView.delegate = self
        return scrollView
    }

    func setupActivityIndicator() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension CartViewController {
    func setupActions() {
        setupHeaderViewAction()
        setupCartProductTableViewAction()
        setupToppingsCollectionView()
        setupPromoActions()
        setupScrollUpButtonAction()
        setupCartButtonAction()
    }

    func setupHeaderViewAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            output.sendAction(.dismissButtonTapped)
        }
    }

    func setupCartProductTableViewAction() {
        orderStackView.onEmptyCart = { [weak self] in
            guard let self else { return }
            output.sendAction(.emptyCartAction)
        }

        // Удаляем позицию из заказа и опять фетчим заказы
        orderStackView.onItemDeletedFromCart = { [weak self] indexPath in
            self?.output.sendAction(.deleteItemTapped(indexPath))
        }

        // Изменяем кол-во единиц товара в корзине
        orderStackView.onCountChanged = { [weak self] indexPath, count in
            print(#function)
            self?.output.sendAction(.changeCountOfItemsTapped(indexPath, count))
        }

        // Нажали на ячейку в таблице с товаром, отправили редактируемый товар в хранилище и открыли экран с этим товаром, при закрытии этого экрана срабатывает комплишн и мы заново загружаем корзину
        orderStackView.onItemCellSelected = { [weak self] item in
            self?.output.sendAction(.itemSelected(item))
        }
    }

    // При нажатии на кнопку двигает скролл на самый верх
    func setupScrollUpButtonAction() {
        scrollUpButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            scrollToTop()
        }
    }

    func setupPromoActions() {
        promoStackView.onPromoSelected = { [weak self] promo in
            guard let self else { print("We can't show promoVC"); return }
            output.sendAction(.promoSelected(promo))
        }
    }

    // Добавляем новую позицию в заказ
    func setupToppingsCollectionView() {
        itemsToAddStackView.onNewItemToAddToCart = { [weak self] itemToAddToOrder in
            guard let self else { return }
            output.sendAction(.addNewItemToCartTapped(itemToAddToOrder))
        }
    }

    func setupCartButtonAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            self?.output.sendAction(.cartButtonTapped)
        }
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

// MARK: - Update UI
private extension CartViewController {
    func updateUIWithData(with data: CartData) {
        promoCollectionUpdateUI(data.promo)
        updateItemsToAdd(data.itemsToAdd)
        updateCart(data.cart)
        updateUI(data.countOfItemsInCart, data.totalCartPrice)
    }

    // Передаем данные в коллекцию и обновляем ее
    func promoCollectionUpdateUI(_ promo: [Promo]?) {
        guard let promo else { return }
        promoStackView.updateUI(promo)
    }

    // Передаем данные в коллекцию (товары для отражения в категории "Добавить к заказу")
    func updateItemsToAdd(_ items: [Item]?) {
        guard let items else { return }
        itemsToAddStackView.getItemsToAdd(items)
        itemsToAddStackView.setState(.success)
    }

    // Передаем данные о корзине для отражения на view
    func updateCart(_ cart: Cart?) {
        guard let cart else { return }
        orderStackView.getCart(cart)
    }

    func updateUI(_ countOfItems: Int?, _ totalPrice: Int?) {
        guard let countOfItems, let totalPrice else { return }
        updateOrderData(countOfItems, totalPrice)
        updateDodoCoinsView(countOfItems, totalPrice)
        updateCartButtonPrice(totalPrice)
    }
}

// MARK: - Supporting methods
private extension CartViewController {
    func isShowContent(_ bool: Bool) {
        contentStack.alpha = bool ? 1 : 0
    }

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

// MARK: - Data Binding
//private extension CartViewController {
//    func dataBinding() {
//        viewModel.promoPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] promo in
//                self?.promoCollectionUpdateUI(promo)
//            }
//            .store(in: &cancellables)
//
//        viewModel.itemsToAddPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] items in
//                self?.updateItemsToAdd(items)
//            }
//            .store(in: &cancellables)
//
//        viewModel.cartPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] cart in
//                self?.updateCart(cart)
//            }
//            .store(in: &cancellables)
//
//        viewModel.countAndTotalPublishers
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] countOfItems, totalPrice in
//                self?.updateUI(countOfItems, totalPrice)
//            }
//            .store(in: &cancellables)
//    }
//}

//    func setState(_ state: ScreenState) {
//        promoStackView.setState(state)
//    }
