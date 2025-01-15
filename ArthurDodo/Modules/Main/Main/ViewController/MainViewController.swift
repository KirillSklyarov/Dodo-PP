import UIKit

protocol MainViewControllerInput: BaseViewControllerInput where inputData == MainData {
    func updateStories()
    func updateCart(with data: MainData)
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = MainHeaderView() // Заголовок с кнопками
    private lazy var orderView = OrderMainVCView() // Вью с заказом (или скрыто или показывается)
    private lazy var contentCollectionView = ContentCollectionView() // Основная коллекция с товарами
    private lazy var cartButton = AppButtons(type: .cartMain) // Кнопка корзины

    private lazy var contentStackView = AppStackView([headerView, orderView, contentCollectionView], axis: .vertical, spacing: 5)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Output
    let output: any MainViewControllerOutput

    // MARK: - Init
    init(output: any MainViewControllerOutput) {
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

    // Каждый раз когда появляется экран мы обновляем статус корзины, чтобы понять показывать ее или нет
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.sendAction(.updateCart)
    }
}

// MARK: - MainViewControllerInput
extension MainViewController: MainViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    func showLoading() {
        activityIndicator.startAnimating()
        setStateOnContent(.loading)
        isShowContent(false)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }

    func configure(with data: MainData) {
        activityIndicator.stopAnimating()
        isShowContent(true)
        updateUI(with: data)
        setStateOnContent(.success)
    }

    // Обновляем сторисы
    func updateStories() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    func updateUI(with data: MainData) {
        updateHeaderView(with: data)
        updateOrderView(with: data)
        updateCollectionView(with: data)
        updateCart(with: data)
        updateUIWithFeatureToggle(with: data)
    }

    // При каждом показе экрана мы запрашиваем актуальную корзину и если там есть позиции, то обновляем сумму на кнопке
    func updateCart(with data: MainData) {
        guard let totalPrice = data.cartPrice else { return }
        cartButton.updateCart(with: totalPrice)
    }
}

// MARK: - Update UI components
private extension MainViewController {
    // Обновляем адрес и кол-во додоКоинов в хэдере
    func updateHeaderView(with data: MainData) {
        guard let address = data.headerData?.mainAddress,
              let dodoCoins = data.headerData?.userDodoCoins else { print("😱 Ошибка обновления хэдера"); return }
        headerView.updateUI(address, dodoCoins)
    }

    // Либо показывает orderView, либо не показывает (выставляет высоту 0), если есть активный заказ, то показываем его детали
    func updateOrderView(with data: MainData) {
        guard let order = data.order,
              let isActiveOrder = order.isActiveOrder else { return }
        orderView.calculateHeight(isActiveOrder)
        if isActiveOrder { updateOrder(order.orderStatus, order.orderPrice) }
    }

    // Обновляем orderView (передаем заказ и сумму заказа)
    func updateOrder(_ orderStatus: String?, _ totalPrice: Int?) {
        guard let orderStatus, let totalPrice else { return }
        orderView.getOrder(orderStatus, totalPrice)
    }

    // Обновляем все данные в главной коллекции
    func updateCollectionView(with data: MainData) {
        updateStoriesSection(with: data)
        updatePromoSection(with: data)
        updateCatalogSection(with: data)
        updateCategoriesSection(with: data)
    }

    // Обновляем секцию сторисов в contentCollectionView
    func updateStoriesSection(with data: MainData) {
        guard let stories = data.stories else { return }
        contentCollectionView.getStories(stories)
    }

    // Обновляем секцию спецпредложений в contentCollectionView
    func updatePromoSection(with data: MainData) {
        guard let promo = data.promoItems else { return }
        contentCollectionView.getSpecialOffers(promo)
    }

    // Обновляем секцию категорий в contentCollectionView
    func updateCategoriesSection(with data: MainData) {
        guard let categories = data.categories else { return }
        contentCollectionView.getCategories(categories)
    }

    // Передаем каталог в contentCollectionView
    func updateCatalogSection(with data: MainData) {
        guard let catalogue = data.catalog else { return }
        contentCollectionView.getCatalog(catalogue)
    }

    // Обновляем UI с учетом featureToggle: включаем или выключаем их
    func updateUIWithFeatureToggle(with data: MainData) {
        guard let isVisible = data.featureToggle?.values.first else { return }
        showProfileFeature(isVisible)
    }
}

// MARK: - Supporting methods
private extension MainViewController {
    // Показываем или скрываем контент
    func isShowContent(_ show: Bool) {
        let uiComponents = [contentStackView]
        uiComponents.forEach { $0.alpha = show ? 1 : 0 }
    }

    // Метод устанавливает
    func setState(view: MainModuleViews, screenState: ScreenState) {
        switch view {
        case .headerView: headerView.setState(screenState)
        case .contentCollectionView:
            contentCollectionView.setState(screenState)
        case .orderView: break
        }
    }

    // Устанавливаем состояние во всем контенте
    func setStateOnContent(_ state: ScreenState) {
        setState(view: .headerView, screenState: state)
        setState(view: .contentCollectionView, screenState: state)
    }

    // Показываем или скрываем фичу профиля
    func showProfileFeature(_ isVisible: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.headerView.showProfileFeature(isVisible)
        }
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView, cartButton, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
        setupCartButtonLayout()
        setupActivityIndicatorLayout()
    }

    // Настраиваем расположение стека с контентом
    func setupContentStackViewLayout() {
        contentStackView.setConstraints(isSafeArea: true)
    }

    // Настраиваем расположение кнопки
    func setupCartButtonLayout() {
        cartButton.setLocalConstraints(isSafeArea: true, bottom: 20, right: 20)
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension MainViewController {
    func setupActions() {
        setupHeaderView()
        setupCollectionView()
        setupCartButtonActions()
    }

    // Настройка замыканий HeaderView
    func setupHeaderView() {
        headerView.onProfileButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            output.sendAction(.profileButtonTapped)
        }

        headerView.onAddressTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            output.sendAction(.addressButtonTapped)
        }
    }

    // Настройка замыканий ContentCollectionView
    func setupCollectionView() {
        contentCollectionView.onStoriesCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            output.sendAction(.storyTapped(at: indexPath))
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            guard let self else { print("Error: self is nil"); return }
            output.sendAction(.promoItemSelected(at: IndexPath))
        }

        contentCollectionView.onItemCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            output.sendAction(.itemSelected(at: indexPath))
        }
    }

    // Настройка замыканий кнопки корзины
    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            output.sendAction(.cartButtonTapped)
        }
    }
}
