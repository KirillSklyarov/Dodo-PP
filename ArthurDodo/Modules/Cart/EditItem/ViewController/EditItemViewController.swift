import UIKit
import AppUIComponentsSPM

protocol EditItemViewControllerInput: BaseViewControllerInput where inputData == ( CartItem, [Topping], WeightPrice) {

}

// Класс, который отвечает за показ экрана с редактированием товара
final class EditItemViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProductHeaderView(type: .itemEdit) // Заголовок с названием
    private lazy var itemDetailsView = EditItemDetailsView() // Основной блок с картинкой и сегментами
    private lazy var infoAndToppingsContainer = InfoAndToppingsView() // Блок с составом и топпингами
    private lazy var cartButtonView = EditCartButtonView() // Блок с ценой и кнопкой

    private lazy var contentStack = AppStackView([itemDetailsView, infoAndToppingsContainer], axis: .vertical, spacing: 5)
    private lazy var scrollView = configScrollView()

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Presenter
    let output: any EditItemViewControllerOutput

    // MARK: - Init
    init(output: any EditItemViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - EditProductViewControllerInput
extension EditItemViewController: EditItemViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }
    
    func showLoading() {
        isShowContent(false)
        activityIndicator.startAnimating()
    }

    func configure(with data: (CartItem, [Topping], WeightPrice)) {
        activityIndicator.stopAnimating()
        updateUI(with: data.0)
        updateToppings(data.1)
        updateUIWithChosenSize(data.2)
        isShowContent(true)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Setup UI
private extension EditItemViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(scrollView, headerView, cartButtonView, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        setupScrollViewLayout()
        setupContentViewLayout()
        setupProductHeaderViewLayout()
        setupCartButtonLayout()
        setupActivityIndicatorLayout()
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
        headerView.setLocalConstraints(top: 0, left: 0, right: 0)
    }

    func setupCartButtonLayout() {
        cartButtonView.setLocalConstraints(bottom: 0, left: 0, right: 0)
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

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension EditItemViewController {
    func setupActions() {
        setupHeaderAction()
        setupCartViewAction()
        setupSizeSegmentAction()
        setupInfoButtonAction()
    }

    // Отрабатываем коллбэк для закрытия окна
    func setupHeaderAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.output.sendAction(.dismissButtonTapped)
        }
    }

    // Когда нажимаем на кнопку корзины на экране, то формируем позицию (кастим Item -> CartItem) для корзины, и добавляем позицию для заказа в хранилище
    func setupCartViewAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            self?.output.sendAction(.cartButtonTapped)
        }
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSizeValueChanged = { [weak self] size in
            self?.output.sendAction(.itemSizeChanged(size))
        }

        itemDetailsView.onDoughValueChanged = { [weak self] dough in
            self?.output.sendAction(.itemDoughChanged(dough))
        }
    }

    func setupInfoButtonAction() {
        infoAndToppingsContainer.onShowPopupVC = { [weak self] popupVC in
            guard let self else { print("Self is nil"); return }
            output.sendAction(.showPopupViewTapped(popupVC))
        }
    }
}

// MARK: - Update UI
private extension EditItemViewController {
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

    func updateUI(with item: CartItem) {
        updateUIWithSelectedItem(item)
        updateSizeAndDough(item.chosenSize, item.chosenDough)
        updateInfo(item)
    }

    func updateUIWithChosenSize(_ productDetails: WeightPrice?) {
        guard let productDetails else { print("Error: productDetails is nil"); return }
        infoAndToppingsContainer.updateUI(with: productDetails)
        let price = productDetails.price
        cartButtonView.updatePriceLabel(price)
    }

    func updateUIWithSelectedItem(_ cartItem: CartItem?) {
        guard let cartItem else { return }
        updateUIWithItem(cartItem)
        isItemPizza(cartItem)
    }

    func updateSizeAndDough(_ size: Size?, _ dough: Dough?) {
        guard let size, let dough else { return }
        itemDetailsView.setChosenSizeAndDough(size, dough)
    }

    func updateInfo(_ item: Item?) {
        guard let item else { return }
        infoAndToppingsContainer.getSelectedItem(item)
    }

    func updateInfo(_ item: CartItem) {
        infoAndToppingsContainer.getSelectedItem(item)
    }

    func updateToppings(_ toppings: [Topping]?) {
        guard let toppings else { return }
        infoAndToppingsContainer.passToppingsToView(toppings)
    }
}

// MARK: - Supporting methods
private extension EditItemViewController {
    // Скрывает и показывает контент в зависимости от вводной переменной
    func isShowContent(_ bool: Bool) {
        let uiComponents = [headerView, contentStack, cartButtonView]
        uiComponents.forEach { $0.alpha = bool ? 1 : 0 }
    }
}
