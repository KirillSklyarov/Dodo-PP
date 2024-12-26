import UIKit
import Combine

protocol ProductDetailsViewControllerProtocol {
    func getViewModel() -> ProductDetailsViewModelProtocol
}

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
    private let viewModel: ProductDetailsViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    var onShowPopupVC: ( (CpfcPopupView) -> Void)?

    // MARK: - Init
    init(viewModel: ProductDetailsViewModel) {
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

        setupSwipe()
    }
}

// MARK: - ProductDetailsViewControllerProtocol
extension ProductDetailsViewController: ProductDetailsViewControllerProtocol {
    func getViewModel() -> ProductDetailsViewModelProtocol {
        viewModel
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
            self?.viewModel.onDismissButtonTapped?()
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
            viewModel.cartButtonTapped(chosenSize, chosenDough)
        }
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSegmentValueChanged = { [weak self] index in
            guard let self else { return }
            viewModel.itemSegmentValueChanged(index)
        }
    }

    func setupInfoButtonAction() {
        infoAndToppingsContainer.onShowPopupVC = { [weak self] popupVC in
            guard let self else { print("Self is nil"); return }
            viewModel.showPopupVC(popupVC)
        }
    }
}

// MARK: - Update UI for The Item (настраиваем экран для конкретного товара)
private extension ProductDetailsViewController {
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
private extension ProductDetailsViewController {
    func setupSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(vcSwiped))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }

    @objc private func vcSwiped() {
        viewModel.onDismissButtonTapped?()
    }
}

// MARK: - Data binding
private extension ProductDetailsViewController {
    func dataBinding() {
        viewModel.itemPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self else { return }
                passSelectedItemToView(item)
                updateUIWithSelectedItem(item)
            }
            .store(in: &cancellables)

        viewModel.isOneSizePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOneSize in
                guard let self else { return }
                isHideSizeSegmentView(isOneSize)
            }
            .store(in: &cancellables)

        viewModel.isDoughOptionPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isDoughOption in
                guard let self else { return }
                isHideDoughSegmentView(isDoughOption)
            }
            .store(in: &cancellables)

        viewModel.weightPricePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weight, price in
                guard let self else { return }
                updateWeightAndPriceUI(weight, price)
            }
            .store(in: &cancellables)

        viewModel.toppingsPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] toppings in
                guard let self else { return }
                passToppingsToView(toppings)
            }
            .store(in: &cancellables)

        viewModel.productDetailsPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] productDetails in
                guard let self else { return }
                updateInfoAndCart(productDetails)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Supporting methods
private extension ProductDetailsViewController {
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
