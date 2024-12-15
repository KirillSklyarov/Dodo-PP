import UIKit

// Класс, который отвечает за показ экрана с редактированием товара
final class EditProductViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProductHeaderView() // Заголовок с названием
    private lazy var itemDetailsView = EditItemDetailsView() // Основной блок с картинкой и сегментами
    private lazy var infoAndToppingsContainer = InfoAndToppingsView() // Блок с составом и топпингами
    private lazy var cartButtonView = EditCartButtonView() // Блок с ценой и кнопкой

    private lazy var contentStack = AppStackView([itemDetailsView, infoAndToppingsContainer], axis: .vertical, spacing: 5)
    private lazy var scrollView = configScrollView()

    // MARK: - Presenter
    let presenter: EditProductPresenter

    // MARK: - Init
    init(presenter: EditProductPresenter) {
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
}

// MARK: - Setup UI
private extension EditProductViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(scrollView, headerView, cartButtonView)
        setupLayout()
    }

    func configScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = AppColors.backgroundGray
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

        scrollView.addSubviews(contentStack)

        return scrollView
    }

    func setupLayout() {
        setupScrollViewLayout()
        setupContentViewLayout()
        setupProductHeaderViewLayout()
        setupCartButtonLayout()
    }

    func setupScrollViewLayout() {
        scrollView.setLocalConstraints(top: 0, left: 0, right: 0)
        scrollView.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor).isActive = true
    }

    func setupContentViewLayout() {
        contentStack.setConstraints()
        contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    func setupProductHeaderViewLayout() {
        headerView.setViewHeight(.small)
        headerView.setLocalConstraints(top: 0, left: 0, right: 0)
    }

    func setupCartButtonLayout() {
        cartButtonView.setLocalConstraints(bottom: 0, left: 0, right: 0)
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
        headerView.onDismissButtonTapped = { [weak self] in
            self?.presenter.onDismissButtonTapped?()
        }
    }

    // Когда нажимаем на кнопку корзины на экране, то формируем позицию (кастим Item -> CartItem) для корзины, и добавляем позицию для заказа в хранилище
    func setupCartViewAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            presenter.cartButtonTapped()
        }
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSizeValueChanged = { [weak self] size in
            guard let self else { return }
            print(#function)
            presenter.itemSizeChanged(size)
        }

        itemDetailsView.onDoughValueChanged = { [weak self] dough in
            guard let self else { return }
            presenter.itemDoughChanged(dough)
        }
    }

    func setupInfoButtonAction() {
        infoAndToppingsContainer.onShowPopupVC = { [weak self] popupVC in
            guard let self else { print("Self is nil"); return }
            presenter.showPopUP(popupVC)
        }
    }
}

// MARK: - Update UI for The Item (настраиваем экран для конкретного товара)
private extension EditProductViewController {
    // Обновляем все view (название, картинку, вес, состав и цену)
    func updateUIWithItem(_ cartItem: CartItem) {
        let item = cartItem.item
        headerView.updateTitle(item.name)
        itemDetailsView.updatePizzaImage(item.imageName)
        infoAndToppingsContainer.updateIngredientsAndWeight(item)
        cartButtonView.updatePriceLabel(cartItem.price)
    }

    // Если это не пицца, то не нужно показывать поле с тестом
    func isItemPizza(_ cartItem: CartItem) {
        let category = cartItem.item.category
        if category != .pizza {
            itemDetailsView.hideDoughSegment()
        }
    }
}

extension EditProductViewController {
    func updateUIWithChosenSize(_ productDetails: WeightPrice) {
        infoAndToppingsContainer.updateUI(with: productDetails)
        let price = productDetails.price
        cartButtonView.updatePriceLabel(price)
    }

    func updateUIWithSelectedItem(_ cartItem: CartItem) {
        updateUIWithItem(cartItem)
        isItemPizza(cartItem)
    }

    func updateSizeAndDough(_ size: Size, _ dough: Dough) {
        itemDetailsView.setChosenSizeAndDough(size, dough)
    }

    func updateInfo(_ item: Item) {
        infoAndToppingsContainer.getSelectedItem(item)
    }

    func updateToppings(_ toppings: [Topping]) {
        infoAndToppingsContainer.passToppingsToView(toppings)
    }
}
