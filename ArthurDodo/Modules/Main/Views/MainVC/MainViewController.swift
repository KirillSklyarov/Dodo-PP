import UIKit
import Combine

protocol MainViewControllerProtocol: AnyObject {
    func getViewModel() -> any MainViewModelProtocol
    func updateStories()
    func setState(view: MainVCViews, screenState: ScreenState)
}

enum MainVCViews {
    case headerView
    case contentCollectionView
    case orderView
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = MainHeaderView() // Заголовок с кнопками
    private lazy var orderView = OrderMainVCView() // Вью с заказом (или скрыто или показывается)
    private lazy var contentCollectionView = ContentCollectionView() // Основная коллекция с товарами
    private lazy var cartButton = AppButtons(type: .cartMain) // Кнопка корзины

    private lazy var contentStackView = AppStackView([headerView, orderView, contentCollectionView], axis: .vertical, spacing: 5)

    // MARK: - ViewModel
    private let viewModel: any MainViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: any MainViewModelProtocol) {
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

    // Каждый раз когда появляется экран мы обновляем статус корзины, чтобы понять показывать ее или нет
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.sendAction(.updateCart)
    }
}

// MARK: - MainViewControllerProtocol
extension MainViewController: MainViewControllerProtocol {
    func getViewModel() -> any MainViewModelProtocol {
        viewModel
    }

    // Обновляем сторисы
    func updateStories() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    func setState(view: MainVCViews, screenState: ScreenState) {
        switch view {
        case .headerView: headerView.setState(screenState)
        case .contentCollectionView:
            contentCollectionView.setState(screenState)
        case .orderView: break
        }
    }
}

private extension MainViewController {
    // Передаем категории в contentCollectionView
    func passCategoriesToContentCollectionView(_ categories: [Category]?) {
        guard let categories else { return }
        contentCollectionView.getCategories(categories)
    }

    // Передает спецпредложения в contentCollectionView
    func passPromoToContentCollectionView(_ specialOffers: [Item]?) {
        guard let specialOffers else { return }
        contentCollectionView.getSpecialOffers(specialOffers)
    }

    // Передаем каталог в contentCollectionView
    func passCatalogToContentCollectionView(_ catalogue: [Item]) {
        contentCollectionView.getCatalog(catalogue)
    }

    // Передает состояние в contentCollectionView
    func setStateOnContentCollectionView(_ state: ScreenState) {
        contentCollectionView.setState(state)
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView, cartButton)
        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
        setupCartButtonLayout()
    }

    // Настраиваем расположение стека с контентом
    func setupContentStackViewLayout() {
        contentStackView.setConstraints(isSafeArea: true)
    }

    // Настраиваем расположение кнопки
    func setupCartButtonLayout() {
        cartButton.setLocalConstraints(isSafeArea: true, bottom: 20, right: 20)
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
            viewModel.sendAction(.profileButtonTapped)
        }

        headerView.onAddressTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            viewModel.sendAction(.addressButtonTapped)
        }
    }

    // Настройка замыканий ContentCollectionView
    func setupCollectionView() {
        contentCollectionView.onStoriesCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            viewModel.sendAction(.storyTapped(at: indexPath))
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            guard let self else { print("Error: self is nil"); return }
            viewModel.sendAction(.promoItemSelected(at: IndexPath))
        }

        contentCollectionView.onItemCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            viewModel.sendAction(.itemSelected(at: indexPath))
        }
    }

    // Настройка замыканий кнопки корзины
    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            viewModel.sendAction(.cartButtonTapped)
        }
    }
}

// MARK: - Data binding
private extension MainViewController {
    func dataBinding() {
        headerViewDataBinding()
        orderViewDataBinding()
        contentCollectionViewDataBinding()
        cartDataBinding()

        featureToggleDataBinding()
    }
}

// MARK: - Header Binding
private extension MainViewController {
    func headerViewDataBinding() {
        // Показывает данные для HeaderView - адрес и додоКоины
        viewModel.addressDodoCoins
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] address, dodoCoins in
                guard let self else { print("Error: self is nil"); return }
                updateHeaderView(address, dodoCoins)
            }
            .store(in: &cancellables)
    }

    // Обновляем адрес и кол-во додоКоинов в хэдере
    func updateHeaderView(_ addressName: String?, _ userDodoCoins: Int?) {
        guard let addressName, let userDodoCoins else { return }
        headerView.updateUI(addressName, userDodoCoins)
    }
}

// MARK: - Order Data Binding
private extension MainViewController {
    func orderViewDataBinding() {
        // Показывает или скрывает OrderView
        viewModel.isShowOrderViewPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isNeedToShowOrder in
                guard let self else { print("Error: self is nil"); return }
                isShowOrderView(isNeedToShowOrder)
            }
            .store(in: &cancellables)

        // Показывает данные для OrderView (статус заказа и стоимость заказа)
        viewModel.orderPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orderStatus, orderPrice in
                guard let self else { print("Error: self is nil"); return }
                updateOrder(orderStatus, orderPrice)
                isShowOrderView(true)
            }
            .store(in: &cancellables)
    }

    // Либо показывает orderView, либо не показывает (выставляет высоту 0)
    func isShowOrderView(_ isActiveOrder: Bool) {
        orderView.calculateHeight(isActiveOrder)
    }

    // Обновляем orderView (передаем заказ и сумму заказа)
    func updateOrder(_ orderStatus: String?, _ totalPrice: Int?) {
        guard let orderStatus, let totalPrice else { return }
        orderView.getOrder(orderStatus, totalPrice)
    }
}

// MARK: - Cart data binding
private extension MainViewController {
    func cartDataBinding() {
        // Показывает данные для корзины
        viewModel.cartPricePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cartPrice in
                guard let self else { print("Error: self is nil"); return }
                updateCart(with: cartPrice)
            }
            .store(in: &cancellables)
    }

    // При каждом показе экрана мы запрашиваем актуальную корзину и если там есть позиции, то обновляем сумму на кнопке
    func updateCart(with totalPrice: Int) {
        cartButton.updateCart(with: totalPrice)
    }
}

private extension MainViewController {
    func contentCollectionViewDataBinding() {
        // Показывает данные для сторисов
        viewModel.storiesPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stories in
                guard let self else { print("Error: self is nil"); return }
                passStoriesToContentCollectionView(stories)
                setState(view: .contentCollectionView, screenState: .success)
            }
            .store(in: &cancellables)

        // Показывает данные для спецпредложения
        viewModel.promoItemsPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] promoItems in
                guard let self else { print("Error: self is nil"); return }
                passPromoToContentCollectionView(promoItems)
            }
            .store(in: &cancellables)

        // Показывает данные для категорий
        viewModel.categoriesPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self else { print("Error: self is nil"); return }
                passCategoriesToContentCollectionView(categories)
            }
            .store(in: &cancellables)

        // Показывает каталог
        viewModel.catalogPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] catalog in
                guard let self else { print("Error: self is nil"); return }
                passCatalogToContentCollectionView(catalog)
            }
            .store(in: &cancellables)

        // Выставляет статус для экрана
        viewModel.statePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { print("Error: self is nil"); return }
                setStateOnContentCollectionView(state)
            }
            .store(in: &cancellables)
    }

    // Передаем сторисы в contentCollectionView
    func passStoriesToContentCollectionView(_ stories: [Story]?) {
        guard let stories else { return }
        contentCollectionView.getStories(stories)
    }

    func featureToggleDataBinding() {
        viewModel.isShowProfileButtonPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                guard let self else { print("Error: self is nil"); return }
                showProfileFeature(isVisible)
            }
            .store(in: &cancellables)

        viewModel.headerStatePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { print("Error: self is nil"); return }
                headerView.setState(state)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Disable profile feature
private extension MainViewController {
    // Показываем или скрываем фичу профиля
    func showProfileFeature(_ isVisible: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.headerView.showProfileFeature(isVisible)
        }
    }
}
