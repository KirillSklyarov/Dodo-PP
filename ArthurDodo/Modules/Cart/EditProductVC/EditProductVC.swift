import UIKit

// Класс, который отвечает за показ экрана с редактирование товара
final class EditProductViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProductHeaderView() // Заголовок с названием
    private lazy var itemDetailsView = DetailsView2() // Основной блок с картинкой и сегментами
    private lazy var infoAndToppingsContainer = InfoAndToppingsView() // Блок с составом и топпингами
    private lazy var cartButtonView = EditCartButtonView() // Блок с ценой и кнопкой

    private lazy var contentStack = AppStackView([itemDetailsView, infoAndToppingsContainer], axis: .vertical, spacing: 5)
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let storage: DataStorage

    private var cartItem: CartItem?
    private var toppings: [Topping] = []

    var onCartButtonTapped: ( () -> Void )?
    var onDismissButtonTapped: ( () -> Void )?
    var onShowPopupVC: ( (CpfcPopupView) -> Void )?

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
}

// MARK: - Setup UI
private extension EditProductViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        configScrollView()
        setupLayout()
    }

    func configScrollView() {
        view.addSubviews(scrollView, headerView, cartButtonView)

        scrollView.backgroundColor = AppColors.backgroundGray
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

        scrollView.addSubviews(contentStack)
    }

    func setupLayout() {
        setupScrollViewLayout()
        setupContentViewLayout()
        setupProductHeaderViewLayout()
        setupCartButtonLayout()
    }

    func setupScrollViewLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor)
        ])
    }

    func setupContentViewLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    func setupProductHeaderViewLayout() {
        headerView.setViewHeight(60)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupCartButtonLayout() {
        NSLayoutConstraint.activate([
            cartButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Setup Actions
private extension EditProductViewController {
    func setupActions() {
        setupHeaderAction()
        setupCartViewAction()
        setupSizeSegmentAction()
        setupInfoButtonAction()
    }

    // Отрабатываем коллбэк для закрытия окна
    func setupHeaderAction() {
        headerView.onCloseButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }

    // Когда нажимаем на кнопку корзины на экране, то формируем позицию (кастим Item -> CartItem) для корзины, и добавляем позицию для заказа в хранилище
    func setupCartViewAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            guard let cartItem else { return }

            storage.changeItemInCart(cartItem)
            onCartButtonTapped?()
        }
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSizeValueChanged = { [weak self] size in
            guard let self else { return }
            guard let size else { print("1. We have some problems here"); return }
            cartItem?.chosenSize = size
            updateUIWithChosenSize(size)
        }

        itemDetailsView.onDoughValueChanged = { [weak self] dough in
            guard let self else { return }
            cartItem?.chosenDough = dough
        }
    }

    func updateUIWithChosenSize(_ size: Size) {
        guard let cartItem else { print("CartItem is nil"); return }
        guard let productDetails = storage.getProductDetails(cartItem, size: size) else {print("2. We have some problems here"); return }
        infoAndToppingsContainer.updateUI(productDetails: productDetails)
        let price = productDetails.price
        self.cartItem?.price = price
        cartButtonView.updatePriceLabel(price)
    }

    func setupInfoButtonAction() {
        infoAndToppingsContainer.onShowPopupVC = { [weak self] popupVC in
            guard let self else { print("Self is nil"); return }
            guard let popupVC = popupVC as? CpfcPopupView else {
                print("No popupVC"); return }
            onShowPopupVC?(popupVC)
        }
    }
}

// MARK: - Fetch Data
private extension EditProductViewController {
    func fetchData() {
        fetchSelectedItem()
        fetchToppings()
    }

    func fetchSelectedItem() {
        guard let cartItem = storage.getChangingCartItem() else { print("No changing item"); return }
        self.cartItem = cartItem

        updateUIWithCorrectSizeAndDough()
        updateUIWithCorrectWeightAndIngredients()
        updateUIWithSelectedItem()
    }

    func updateUIWithCorrectSizeAndDough() {
        guard let cartItem else { return }
        let size = cartItem.chosenSize
        guard let dough = cartItem.chosenDough else { print("No dough"); return }
        itemDetailsView.setChosenSizeAndDough(size, dough)
    }

    func updateUIWithCorrectWeightAndIngredients() {
        guard let cartItem else { print("Cart item is nil"); return }
        infoAndToppingsContainer.getSelectedItem(cartItem.item)
    }

    // Загружаем ВСЕ начинки
    func fetchToppings() {
        storage.fetchToppings()
        storage.onToppingsFetchedSuccessfully = { [weak self] fetchedToppings in
            guard let self else { return }
            filterToppings()
        }
    }

    // Отбираем только нужные нам начинки
    func filterToppings() {
        guard let cartItem else { return }
        guard let toppings = storage.getFetchedToppings(for: cartItem) else { return }
        passToppingsToView(toppings)
    }

    // Отправляем данные о топпингов дальше ко вью
    func passToppingsToView(_ toppings: [Topping]) {
        infoAndToppingsContainer.passToppingsToView(toppings)
    }
}

// MARK: - Update UI for The Item (настраиваем экран для конкретного товара)
private extension EditProductViewController {
    func updateUIWithSelectedItem() {
        updateUIWithItem()
        isItemPizza()
    }

    func updateUIWithItem() {
        guard let cartItem else { return }
        let item = cartItem.item

        headerView.updateTitle(cartItem.item.name)
        itemDetailsView.updatePizzaImage(cartItem.item.imageName)
        infoAndToppingsContainer.updateIngredientsAndWeight(item)
        cartButtonView.updatePriceLabel(cartItem.price)
    }

    // Если это не пицца, то не нужно показывать поле с тестом
    func isItemPizza() {
        if cartItem?.item.category != .pizza {
            itemDetailsView.hideDoughSegment()
        }
    }
}
