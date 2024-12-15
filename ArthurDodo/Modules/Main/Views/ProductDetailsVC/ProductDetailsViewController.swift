import UIKit

// Класс, который отвечает за показ экрана с товаром (где фотка, описание, ингредиенты, состав и проч.)
final class ProductDetailsViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProductHeaderView()
    private lazy var itemDetailsView = DetailsView()
    private lazy var infoAndToppingsContainer = InfoAndToppingsView()
    private lazy var cartButtonView = AppCartButtonView(type: .itemDetail)
    private lazy var contentStack = AppStackView( [itemDetailsView, infoAndToppingsContainer], axis: .vertical, spacing: 5)
   
    private lazy var scrollView = configScrollView()

    // MARK: - Presenter
    let presenter: ProductDetailsPresenter

    var onShowPopupVC: ( (CpfcPopupView) -> Void)?

    // MARK: - Init
    init(presenter: ProductDetailsPresenter) {
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
        setupSwipe()
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

// MARK: - Setup UI
private extension ProductDetailsViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(scrollView, headerView, cartButtonView)
        setupConstraints()
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
}

// MARK: - Setup Actions
private extension ProductDetailsViewController {
    func setupActions() {
        setupHeaderAction()
        sendCartToInfoView()
        setupCartViewAction()
        setupSizeSegmentAction()
        setupInfoButtonAction()
    }

    func setupHeaderAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.presenter.onDismissButtonTapped?()
        }
    }

    func sendCartToInfoView() {
        infoAndToppingsContainer.getCartView(cartButtonView)
    }

    // Когда нажимаем на кнопку корзины на экране, то формируем позицию (кастим Item -> CartItem) для корзины, добавляем позицию для заказа в хранилище и закрываем окно
    func setupCartViewAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            presenter.cartButtonTapped()
        }
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSegmentValueChanged = { [weak self] index in
            guard let self else { return }
            presenter.itemSegmentValueChanged(index)
        }
    }

//    func updateUIWithChosenSize(_ index: Int) {
//        guard let productDetails = item?.itemSize.getWeightAndPriceViaIndex(index) else { print("We have some problems here"); return }
//        infoAndToppingsContainer.updateUI(productDetails: productDetails)
//        let price = productDetails.price
//        cartButtonView.updatePrice(price)
//    }

    func setupInfoButtonAction() {
        infoAndToppingsContainer.onShowPopupVC = { [weak self] popupVC in
            guard let self else { print("Self is nil"); return }
//            guard let popupVC = popupVC as? CpfcPopupView else {
//                print("No popupVC"); return }
            presenter.showPopupVC(popupVC)
        }
    }
}

// MARK: - Update UI for The Item (настраиваем экран для конкретного товара)
extension ProductDetailsViewController {

    // Обновляем все поля
    func updateUIWithSelectedItem(_ item: Item) {
        headerView.updateTitle(item.name)
        itemDetailsView.updatePizzaImage(item.imageName)

        infoAndToppingsContainer.updateIngredientsAndWeight(item)
        cartButtonView.updatePrice(item.itemSize.medium?.price ?? 0)
    }

    // Если это не пицца, то не нужно показывать поле с тестом
    func hideDoughSegmentView() {
        itemDetailsView.hideDoughSegment()
    }

    // Если размер один, то не нужно показывать поле с размерами
    func hideSizeSegmentView() {
        itemDetailsView.hideSizeSegment()
    }

    // Если размер один, то обновляем вес и цену товара
    func updateWeightAndPriceUI(_ weight: Int, _ price: Int) {
        infoAndToppingsContainer.updateWeight(weight)
        cartButtonView.updatePrice(price)
    }

    func passSelectedItemToView(_ item: Item) {
        infoAndToppingsContainer.getSelectedItem(item)
    }

    func passToppingsToView(_ toppings: [Topping]) {
        infoAndToppingsContainer.passToppingsToView(toppings)
    }
}

// MARK: - Setup dismiss by swipe
private extension ProductDetailsViewController {
    func setupSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(vcSwiped))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }

    @objc private func vcSwiped() {
        presenter.onDismissButtonTapped?()
    }
}
