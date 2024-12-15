import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func updateCart(with totalPrice: Int)
    func updateOrder(_ order: Order, _ totalPrice: Int)
    func updateHeaderView(_ addressName: String, _ userDodoCoins: Int)
    func passStoriesToContentCollectionView(_ stories: [Story])
    func passCategoriesToContentCollectionView(_ categories: [Category])
    func passPromoToContentCollectionView(_ specialOffers: [Item])
    func passCatalogToContentCollectionView(_ catalogue: [Item])
    func setStateOnContentCollectionView(_ state: ScreenState)
    func isShowOrderView(_ isActiveOrder: Bool)
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = MainHeaderView() // Заголовок с кнопками
    private lazy var orderView = OrderMainVCView() // Вью с заказом (или скрыто или показывается)
    private lazy var contentCollectionView = ContentCollectionView() // Основная коллекция с товарами
    private lazy var cartButton = AppButtons(type: .cartMain) // Кнопка корзины

    private lazy var contentStackView = AppStackView([headerView, orderView, contentCollectionView], axis: .vertical, spacing: 5)

    // MARK: - Presenter
    let presenter: MainPresenterProtocol

    // MARK: - Init
    init(presenter: MainPresenterProtocol) {
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

    // Каждый раз когда появляется экран мы обновляем статус корзины, чтобы понять показывать ее или нет
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateCart()
    }
}

// MARK: - MainViewControllerProtocol
extension MainViewController: MainViewControllerProtocol {
    // Обновление коллекции
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadData()
        }
    }

    // Обновляем сторисы
    func updateStories() {
        DispatchQueue.main.async { [weak self] in
            self?.contentCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    // При каждом показе экрана мы запрашиваем актуальную корзину и если там есть позиции, то обновляем сумму на кнопке
    func updateCart(with totalPrice: Int) {
        cartButton.updateCart(with: totalPrice)
    }

    // Обновляем orderView (передаем заказ и сумму заказа)
    func updateOrder(_ order: Order, _ totalPrice: Int) {
        orderView.getOrder(order, totalPrice)
    }

    // Обновляем адрес и кол-во додоКоинов в хэдере
    func updateHeaderView(_ addressName: String, _ userDodoCoins: Int) {
        headerView.updateUI(addressName, userDodoCoins)
    }

    // Передаем сторисы в contentCollectionView
    func passStoriesToContentCollectionView(_ stories: [Story]) {
        contentCollectionView.getStories(stories)
    }

    // Передаем категории в contentCollectionView
    func passCategoriesToContentCollectionView(_ categories: [Category]) {
        contentCollectionView.getCategories(categories)
    }

    // Передает спецпредложения в contentCollectionView
    func passPromoToContentCollectionView(_ specialOffers: [Item]) {
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
            presenter.profileButtonTapped()
        }

        headerView.onAddressTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            presenter.addressButtonTapped()
        }
    }

    // Настройка замыканий ContentCollectionView
    func setupCollectionView() {
        contentCollectionView.onItemCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            presenter.itemSelected(at: indexPath)
        }

        contentCollectionView.onStoriesCellTapped = { [weak self] indexPath in
            guard let self else { print("Error: self is nil"); return }
            presenter.storyTapped(at: indexPath)
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            guard let self else { print("Error: self is nil"); return }
            presenter.promoItemSelected(at: IndexPath)
        }
    }

    // Настройка замыканий кнопки корзины
    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            presenter.cartButtonTapped()
        }
    }
}
