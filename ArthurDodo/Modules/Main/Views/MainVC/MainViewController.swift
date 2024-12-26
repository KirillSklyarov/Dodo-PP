import UIKit
import Combine

protocol MainViewControllerProtocol: AnyObject {
    func getViewModel() -> MainViewModelProtocol
    func updateStories()
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = MainHeaderView() // Заголовок с кнопками
    private lazy var orderView = OrderMainVCView() // Вью с заказом (или скрыто или показывается)
    private lazy var contentCollectionView = ContentCollectionView() // Основная коллекция с товарами
    private lazy var cartButton = AppButtons(type: .cartMain) // Кнопка корзины

    private lazy var contentStackView = AppStackView([headerView, orderView, contentCollectionView], axis: .vertical, spacing: 5)

    // MARK: - Presenter
    private let viewModel: MainViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: MainViewModelProtocol) {
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
        viewModel.updateCart()
    }
}

// MARK: - MainViewControllerProtocol
extension MainViewController: MainViewControllerProtocol {
    func getViewModel() -> MainViewModelProtocol {
        viewModel
    }

    // Обновляем сторисы
    func updateStories() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

private extension MainViewController {
    // Обновление коллекции
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadData()
        }
    }

    // При каждом показе экрана мы запрашиваем актуальную корзину и если там есть позиции, то обновляем сумму на кнопке
    func updateCart(with totalPrice: Int) {
        cartButton.updateCart(with: totalPrice)
    }

    // Обновляем orderView (передаем заказ и сумму заказа)
    func updateOrder(_ orderStatus: String?, _ totalPrice: Int?) {
        guard let orderStatus, let totalPrice else { return }
        orderView.getOrder(orderStatus, totalPrice)
    }

    // Обновляем адрес и кол-во додоКоинов в хэдере
    func updateHeaderView(_ addressName: String?, _ userDodoCoins: Int?) {
        guard let addressName, let userDodoCoins else { return }
        headerView.updateUI(addressName, userDodoCoins)
    }

    // Передаем сторисы в contentCollectionView
    func passStoriesToContentCollectionView(_ stories: [Story]?) {
        guard let stories else { return }
        contentCollectionView.getStories(stories)
    }

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

    // Либо показывает orderView, либо не показывает (выставляет высоту 0)
    func isShowOrderView(_ isActiveOrder: Bool) {
        orderView.calculateHeight(isActiveOrder)
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
            viewModel.profileButtonTapped()
        }

        headerView.onAddressTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            viewModel.addressButtonTapped()
        }
    }

    // Настройка замыканий ContentCollectionView
    func setupCollectionView() {
        contentCollectionView.onItemCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            viewModel.itemSelected(at: indexPath)
        }

        contentCollectionView.onStoriesCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            viewModel.storyTapped(at: indexPath)
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            guard let self else { print("Error: self is nil"); return }
            viewModel.promoItemSelected(at: IndexPath)
        }
    }

    // Настройка замыканий кнопки корзины
    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            viewModel.cartButtonTapped()
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
    }

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

    func contentCollectionViewDataBinding() {
        // Показывает данные для сторисов
        viewModel.storiesPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stories in
                guard let self else { print("Error: self is nil"); return }
                passStoriesToContentCollectionView(stories)
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
}
