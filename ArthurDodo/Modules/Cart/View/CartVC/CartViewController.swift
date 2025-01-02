import UIKit
import Combine

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
    private let viewModel: CartViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: CartViewModelProtocol) {
        self.viewModel = viewModel
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
        dataBinding()
        viewModel.initialize()
    }

    // Мы обновляем кнопку корзины на mainVC всегда, когда закрывается это окно (либо по свайпу, либо по нажатию на кнопку dismiss, либо по причине пустой корзины)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.cartVCDismissed()
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
            viewModel.cartVCDismissed()
        }
    }

    func setupCartProductTableViewAction() {
        orderStackView.onEmptyCart = { [weak self] in
            guard let self else { return }
            viewModel.cartIsEmpty()
        }

        // Удаляем позицию из заказа и опять фетчим заказы
        orderStackView.onItemDeletedFromCart = { [weak self] indexPath in
            self?.viewModel.deleteItemFromCart(indexPath)
        }

        // Изменяем кол-во единиц товара в корзине
        orderStackView.onCountChanged = { [weak self] indexPath, count in
            self?.viewModel.changeCountOfItem(indexPath, count)
        }

        // Нажали на ячейку в таблице с товаром, отправили редактируемый товар в хранилище и открыли экран с этим товаром, при закрытии этого экрана срабатывает комплишн и мы заново загружаем корзину
        orderStackView.onItemCellSelected = { [weak self] item in
            self?.viewModel.selectItem(item)
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
            viewModel.promoSelected(promo)
        }
    }

    // Добавляем новую позицию в заказ
    func setupToppingsCollectionView() {
        itemsToAddStackView.onNewItemToAddToCart = { [weak self] itemToAddToOrder in
            guard let self else { return }
            viewModel.addNewItemToCartTapped(itemToAddToOrder)

        }
    }

    func setupCartButtonAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            self?.viewModel.cartButtonTapped()
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

    // Настраиваем скролл вью
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.addSubviews(contentStackView, scrollUpButton)
        scrollView.delegate = self
        return scrollView
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
extension CartViewController {
    func getViewModel() -> CartViewModelProtocol {
        viewModel
    }

    func setState(_ state: ScreenState) {
        promoStackView.setState(state)
    }

    func updateUI(_ countOfItems: Int?, _ totalPrice: Int?) {
        guard let countOfItems, let totalPrice else { return }
        updateOrderData(countOfItems, totalPrice)
        updateDodoCoinsView(countOfItems, totalPrice)
        updateCartButtonPrice(totalPrice)
    }

    // Передаем данные в коллекцию и обновляем ее
    func promoCollectionUpdateUI(_ promo: [Promo]?) {
        guard let promo else { return }
        promoStackView.updateUI(promo)
        setState(.success)
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

// MARK: - Data Binding
private extension CartViewController {
    func dataBinding() {
        viewModel.promoPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] promo in
                self?.promoCollectionUpdateUI(promo)
            }
            .store(in: &cancellables)

        viewModel.itemsToAddPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.updateItemsToAdd(items)
            }
            .store(in: &cancellables)

        viewModel.cartPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cart in
                self?.updateCart(cart)
            }
            .store(in: &cancellables)

        viewModel.countAndTotalPublishers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countOfItems, totalPrice in
                self?.updateUI(countOfItems, totalPrice)
            }
            .store(in: &cancellables)
    }
}
