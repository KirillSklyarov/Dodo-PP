import UIKit

final class DeliveryVC: UIViewController {

    // MARK: - UI Properties
    private lazy var addressTableView = DeliveryTableView() // Таблица с адресом
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время доставки"
        label.font = AppFonts.semibold20
        label.textColor = .white
        return label
    }() // Время доставки
    private lazy var timeCollection = TimeCollectionView() // Коллекция со временем
    private lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Оплата"
        label.font = AppFonts.semibold20
        label.textColor = .white
        return label
    }() // Оплата
    private lazy var paymentTableView = PreferredPaymentMethodTableView(preferredPaymentMethod) // Коллекция с методами оплаты
    private lazy var orderDetailsView = DodoCoinsView(title: "Доставка", value: "Бесплатно", textColor: AppColors.grayFont) // Блок с доставкой
    private lazy var totalPriceView = OrderTotalPriceView() // Общая стоимость заказа
    private lazy var payButton = PaymentButtonView(preferredPaymentMethod) // Кнопка оплатить

    // MARK: - Other properties
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    private var preferredPaymentMethod: PaymentMethod = .cbp

    private let storage: DataStorage
    private let router: Router

    // MARK: - Init
    init(storage: DataStorage, router: Router) {
        self.storage = storage
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(_ paymentMethod: PaymentMethod) {
        paymentTableView.updateUI(with: paymentMethod)
        payButton.updateUI(with: paymentMethod)
    }

    func updateAddress(_ addressName: String) {
        addressTableView.updateUI(with: addressName)
        storage.setNewMainAddress(addressName)
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchData()
    }
}

// MARK: - Fetch Data
private extension DeliveryVC {
    func fetchData() {
        fetchAddresses()
        fetchPreferredPaymentMethod()
        fetchOrderDetails()
    }

    // Получаем адреса и обновляем таблицу с активным адресом
    func fetchAddresses() {
        storage.fetchUserAddresses()
        storage.onDataFetchedSuccessfully = { [weak self] in
            guard let self,
                  let mainAddressName = storage.getMainAddress()?.name else { return }
            addressTableView.updateUI(with: mainAddressName)
        }
    }

    // Получаем выбранный способ оплаты и обновляем таблицу со способами и кнопку оплаты
    func fetchPreferredPaymentMethod() {
        preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
        paymentTableView.updateUI(with: preferredPaymentMethod)
        payButton.updateUI(with: preferredPaymentMethod)
    }

    // Получаем общую сумму заказа и обновляем кнопку
    func fetchOrderDetails() {
        let totalPrice = storage.getTotalCartPrice()
        totalPriceView.updateUI(with: totalPrice)
    }
}

// MARK: - Setup UI
private extension DeliveryVC {
    func setupUI() {
        setupNavigationBar()
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(addressTableView, timeLabel, timeCollection, paymentLabel, paymentTableView, orderDetailsView, totalPriceView, payButton)

        setupLayout()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.title = "Доставка"

        let dismissButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = AppColors.buttonOrange
        dismissButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.leftBarButtonItem = dismissButton
    }

    @objc func dismissButtonTapped() {
        router.dismissCurrentVC()
    }

    func setupLayout() {
        setupAddressTableLayout()
        setupTimeLabelLayout()
        setupTimeCollectionLayout()
        setupPaymentLabelLayout()
        setupPaymentTableLayout()
        setupOrderDetailsViewLayout()
        setupTotalPriceViewLayout()
        setupPayButtonLayout()
    }

    func setupAddressTableLayout() {
        NSLayoutConstraint.activate([
            addressTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset),
            addressTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            addressTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupTimeLabelLayout() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: addressTableView.bottomAnchor, constant: topInset*3),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupTimeCollectionLayout() {
        NSLayoutConstraint.activate([
            timeCollection.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: topInset),
            timeCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            timeCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),

            timeCollection.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupPaymentLabelLayout() {
        NSLayoutConstraint.activate([
            paymentLabel.topAnchor.constraint(equalTo: timeCollection.bottomAnchor, constant: topInset*3),
            paymentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            paymentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupPaymentTableLayout() {
        NSLayoutConstraint.activate([
            paymentTableView.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: topInset),
            paymentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            paymentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupOrderDetailsViewLayout() {
        NSLayoutConstraint.activate([
            orderDetailsView.bottomAnchor.constraint(equalTo: totalPriceView.topAnchor, constant: bottomInset),
            orderDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            orderDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupTotalPriceViewLayout() {
        NSLayoutConstraint.activate([
            totalPriceView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: bottomInset),
            totalPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            totalPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupPayButtonLayout() {
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomInset),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }
}

// MARK: - Setup Actions
private extension DeliveryVC {
    func setupActions() {
        setupAddressTableViewAction()
        setupTimeCollectionAction()
        setupPaymentTableView()
        setupPayButtonActions()
    }

    func setupAddressTableViewAction() {
        addressTableView.onCellSelected = { [weak self] in
            guard let self else { return }
            router.showChooseAddress { addressName in
                self.updateAddress(addressName)
            }
        }
    }

    func setupTimeCollectionAction() {
        timeCollection.onDeliveryTimeSelected = { [weak self] time in
            self?.storage.setDeliveryTime(time: time)
        }
    }

    func setupPaymentTableView() {
        paymentTableView.onCellSelected = { [weak self] in
            guard let self else { return }
            router.showChoosePaymentMethod { paymentMethod in
                self.updateUI(paymentMethod)
            }
        }
    }

    func setupPayButtonActions() {
        payButton.onPayButtonTapped = { [weak self] in
            guard let self else { return }
            storage.configureOrder()
            guard let order = storage.getOrderFromStorage() else { print("We have no order"); return }
            setActiveOrderToUserDefaults(order)
            router.showFinalVC()
        }
    }
}

// MARK: - Supporting methods
private extension DeliveryVC {
    // Из массива всех адресов находим основной адрес
    func getMainAddressName(from addresses: [Address]) -> String {
        let mainAddressName = addresses.filter { $0.isMain == true }.first?.name ?? ""
        return mainAddressName
    }

    // Отправляет в UserDefaults инфу, что есть активный заказ
    func setActiveOrderToUserDefaults(_ order: Order) {
        UserDefaults.standard.sendOrder(order)
    }
}
