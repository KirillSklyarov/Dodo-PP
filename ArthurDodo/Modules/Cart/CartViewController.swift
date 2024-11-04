import UIKit

final class CartViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var orderStackView = OrderStackView() // Хэдер и таблица с заказами
    private lazy var itemsToAddStackView = ItemsToAddStackView() // Добавки к заказу
    private lazy var promoStackView = PromoStackView() // Акции
    private lazy var promoButton = PromoButton() // Кнопка Ввести промокод
    private lazy var dodoCoinsView = DodoCoinsStackView() // Блок с додокоинами
    private lazy var cartButtonView = CartButtonView(isCart: true) // Кнопка корзины
    private lazy var scrollUpButton = ScrollUpButton() // Кнопка scrollToTop
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [orderStackView, itemsToAddStackView, promoStackView, promoButton, dodoCoinsView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private var storage: DataStorage
    private var router: AppRouter

    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10

    private var order: [Order]?
    private var promo: [Promo] = []

    var onCartVCDismissed: (() -> Void)?

    init(storage: DataStorage, router: AppRouter, order: [Order]? = nil, onCartVCDismissed: ( () -> Void)? = nil) {
        self.storage = storage
        self.router = router
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
        fetchDataFromStorage()
    }

    // Мы обновляем кнопку корзины на mainVC всегда, когда закрывается это окно (либо по свайпу, либо по нажатию на кнопку dismiss, либо по причине пустой корзины)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onCartVCDismissed?()
    }
}

// MARK: - Fetch Data
private extension CartViewController {
    func fetchDataFromStorage() {
        fetchOrders()
        fetchPromo()
    }

    func fetchOrders() {
        order = storage.getOrderFromStorage()
        updateUI()
    }

    func updateUI() {
        let countOfItems = storage.getCountOfItems()
        let totalPrice = storage.getTotalOrderPrice()
        updateOrderData(countOfItems, totalPrice)
        updateDodoCoinsView(countOfItems, totalPrice)
        updateCartButtonPrice(totalPrice)
    }

    func fetchPromo() {
        promo = storage.getPromoFromStorage()

        if promo.isEmpty {
            fetchPromoFromServer()
        } else {
            promoStackView.updateUI(promo)
        }
    }

    func fetchPromoFromServer() {
        storage.fetchPromo()
        storage.onPromoFetchedSuccessfully = { [weak self] fetchedPromo in
            guard let self else { return }
            promo = fetchedPromo
            promoStackView.updateUI(promo)
        }
    }
}

// MARK: - Setup Actions
private extension CartViewController {
    func setupActions() {
        setupCartProductTableViewAction()
        setupToppingsCollectionView()
        setupSpecialViewActions()
        setupScrollUpButtonAction()
        setupCartButtonAction()
    }

    func setupCartProductTableViewAction() {
        orderStackView.onEmptyCart = { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
        }
        orderStackView.onItemDeletedFromCart = { [weak self] in
            self?.fetchDataFromStorage()
        }
        orderStackView.onCountChanged = { [weak self] in
            self?.fetchOrders()
        }

        orderStackView.onChangeItem = { [weak self] in
            self?.router.navigate(to: .productDetails)
        }
    }

    func setupScrollUpButtonAction() {
        scrollUpButton.onScrollUpButtonTapped = { [weak self] in
            guard let self else { return }
            let topInset = scrollView.adjustedContentInset.top
            scrollView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: true)
        }
    }

    func setupSpecialViewActions() {
        promoStackView.onPromoSelected = { [weak self] specialOffer in
            guard let self else { return }
            router.navigate(to: .applySpecialOffer) { applyOfferVC in
                guard let applyOfferVC = applyOfferVC as? ApplyOfferViewController else { print("We can't cast applyOfferVC"); return }
                applyOfferVC.configureViewController(specialOffer)
            }
        }
    }

    func setupToppingsCollectionView() {
        itemsToAddStackView.onNewItemToAddToCart = { [weak self] in
            guard let self else { return }
            fetchDataFromStorage()
            orderStackView.uploadOrder()
        }
    }

    func setupCartButtonAction() {
        cartButtonView.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            print(#function)
            router.navigate(to: .delivery)
        }
    }
}

// MARK: - Setup UI
private extension CartViewController {
    func setupUI() {
        setupNavigationBar()
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(scrollView, cartButtonView)

        setupScrollView()
        setupLayout()
    }

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Корзина"

        let dismissButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = AppColors.buttonOrange
        dismissButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.leftBarButtonItem = dismissButton
    }

    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }

    func setupScrollView() {
        scrollView.addSubviews(contentStackView, scrollUpButton)
        let bottomInset = cartButtonView.getHeight()
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        scrollView.delegate = self
    }
}

// MARK: - Constraints
extension CartViewController {
    private func setupLayout() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupScrollUpButtonConstraints()
        setupCartButtonConstraints()
    }

    private func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentViewConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
        ])
    }

    private func setupScrollUpButtonConstraints() {
        NSLayoutConstraint.activate([
            scrollUpButton.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor, constant: -5),
            scrollUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
        ])
    }

    private func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UIScrollViewDelegate - настройка кнопки scrollToTop
extension CartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollUpButton.setupScrollUpButtonAction(scrollView: scrollView)
    }
}

// MARK: - Supporting methods
private extension CartViewController {
    func updateDodoCoinsView(_ countOfItems: Int, _ totalPrice: Int) {
        let dodoCoins = totalPrice / 10
        dodoCoinsView.setCountOfItems(countOfItems)
        dodoCoinsView.setTotalPrice(totalPrice)
        dodoCoinsView.setDodoCoins(dodoCoins)
    }

    func updateOrderData(_ countOfItems: Int, _ totalPrice: Int) {
        orderStackView.updateHeader(countOfItems, totalPrice: totalPrice)
    }

    func updateCartButtonPrice(_ totalPrice: Int) {
        cartButtonView.updatePrice(totalPrice)
    }
}
