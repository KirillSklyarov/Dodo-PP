import UIKit
import ActivityIndicatorSPM

protocol ItemDetailsViewControllerInput: BaseViewControllerInput where inputData == ItemDetailsData {
    func changeViewWithSelectedSize(_ itemDetails: WeightPrice)
}

// Класс, который отвечает за показ экрана с товаром (где фотка, описание, ингредиенты, состав и проч.)
final class ItemDetailsViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProductHeaderView()
    private lazy var itemDetailsView = DetailsView()
    private lazy var infoAndToppingsContainer = InfoAndToppingsView()
    private lazy var cartButtonView = AppCartButtonView(type: .itemDetail)
    private lazy var contentStack = AppStackView( [itemDetailsView, infoAndToppingsContainer], axis: .vertical, spacing: 5)

    private lazy var scrollView = configScrollView()

    private lazy var activityIndicator = ActivityIndicatorSPM.AppActivityIndicator()

    // MARK: - Presenter
    let output: any ItemDetailsViewControllerOutput

    // MARK: - Init
    init(output: any ItemDetailsViewControllerOutput) {
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

// MARK: - ItemDetailsViewControllerInput
extension ItemDetailsViewController: ItemDetailsViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        isShowContent(false)
    }
    
    func configure(with itemData: ItemDetailsData) {
        activityIndicator.stopAnimating()
        updateUI(with: itemData)
        isShowContent(true)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }

    func changeViewWithSelectedSize(_ itemDetails: WeightPrice) {
        updateInfoAndCart(itemDetails)
    }
}

// MARK: - Setup UI
private extension ItemDetailsViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(scrollView, headerView, cartButtonView, activityIndicator)
        setupConstraints()

        setupSwipe()
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

    func setupConstraints() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupProductHeaderViewConstraints()
        setupCartButtonConstraints()
        setupActivityIndicatorLayout()
    }

    func setupScrollViewConstraints() {
        scrollView.setLocalConstraints(top: 0, left: 0, right: 0)
        scrollView.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor).isActive = true
    }

    func setupContentViewConstraints() {
        contentStack.setConstraints()
        contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    func setupProductHeaderViewConstraints() {
        headerView.setLocalConstraints(top: 0, left: 0, right: 0)
    }

    func setupCartButtonConstraints() {
        cartButtonView.setLocalConstraints(bottom: 0, left: 0, right: 0)
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension ItemDetailsViewController {
    func setupActions() {
        setupHeaderAction()
        sendCartToInfoView()
        setupCartViewAction()
        setupSizeSegmentAction()
        setupInfoButtonAction()
    }

    func setupHeaderAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.output.sendAction(.dismissButtonTapped)
        }
    }

    func sendCartToInfoView() {
        infoAndToppingsContainer.getCartView(cartButtonView)
    }

    // Когда нажимаем на кнопку корзины на экране, то формируем позицию (кастим Item -> CartItem) для корзины, добавляем позицию для заказа в хранилище и закрываем окно
    func setupCartViewAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            let chosenSize = getChosenSize()
            let chosenDough = getChosenDough()
            output.sendAction(.cartButtonTapped(chosenSize, chosenDough))
        }
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSegmentValueChanged = { [weak self] index in
            guard let self else { return }
            output.sendAction(.itemSegmentValueChanged(index))
        }
    }

    func setupInfoButtonAction() {
        infoAndToppingsContainer.onShowPopupVC = { [weak self] popupVC in
            guard let self else { print("Self is nil"); return }
            output.sendAction(.showPopupVC(popupVC))
        }
    }
}

// MARK: - Update UI for The Item (настраиваем экран для конкретного товара)
private extension ItemDetailsViewController {
    // Метод обновляет все UI элементы 
    func updateUI(with itemData: ItemDetailsData) {
        passSelectedItemToView(itemData.item)
        updateUIWithSelectedItem(itemData.item)
        isHideSizeSegmentView(itemData.isOneSize)
        isHideDoughSegmentView(itemData.isDoughOption)
        updateWeightAndPriceUI(itemData.weight, itemData.price)
        passToppingsToView(itemData.item?.toppings ?? [])
    }

    // Обновляем все поля
    func updateUIWithSelectedItem(_ item: Item?) {
        guard let item else { print("Item is nil"); return }
        headerView.updateTitle(item.name)
        itemDetailsView.updatePizzaImage(item.imageName)

        infoAndToppingsContainer.updateIngredientsAndWeight(item)
        cartButtonView.updatePrice(item.itemSize.medium?.price ?? 0)
    }

    // Если это не пицца, то не нужно показывать поле с тестом
    func isHideDoughSegmentView(_ isDoughOption: Bool?) {
        guard let isDoughOption else { return }
        if !isDoughOption {
            itemDetailsView.hideDoughSegment()
        }
    }

    // Если размер один, то не нужно показывать поле с размерами
    func isHideSizeSegmentView(_ isOneSize: Bool?) {
        guard let isOneSize else { return }
        if isOneSize {
            itemDetailsView.hideSizeSegment()
        }
    }

    // Если размер один, то обновляем вес и цену товара
    func updateWeightAndPriceUI(_ weight: Int?, _ price: Int?) {
        guard let weight, let price else { return }
        infoAndToppingsContainer.updateWeight(weight)
        cartButtonView.updatePrice(price)
    }

    func passSelectedItemToView(_ item: Item?) {
        guard let item else { return }
        infoAndToppingsContainer.getSelectedItem(item)
    }

    func passToppingsToView(_ toppings: [Topping]) {
        infoAndToppingsContainer.passToppingsToView(toppings)
    }
}

// MARK: - Setup dismiss by swipe
private extension ItemDetailsViewController {
    // Настраиваем закрытие окна по свайпу сниз
    func setupSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(vcSwiped))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }

    @objc private func vcSwiped() {
        output.sendAction(.dismissButtonTapped)
    }
}

// MARK: - Supporting methods
private extension ItemDetailsViewController {
    // Показываем или скрываем контент
    func isShowContent(_ show: Bool) {
        let uiComponents = [headerView, contentStack, cartButtonView]
        uiComponents.forEach { $0.alpha = show ? 1 : 0 }
    }

    func getChosenSize() -> Size {
        itemDetailsView.getChosenSize()
    }

    func getChosenDough() -> Dough {
        itemDetailsView.getChosenDough()
    }

    func updateInfoAndCart(_ productDetails: WeightPrice) {
        infoAndToppingsContainer.updateUI(with: productDetails)
        cartButtonView.updatePrice(productDetails.price)
    }
}
