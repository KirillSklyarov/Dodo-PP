import UIKit

final class DeliveryVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = CartHeaderView(title: "Доставка") // Заголовок с кнопкой
    private lazy var addressLabel = DeliveryVCLabel(title: "Адрес доставки") // Адрес доставки
    private lazy var addressTableView = AddressTableView() // Таблица с адресом
    private lazy var timeLabel = DeliveryVCLabel(title: "Время доставки") // Время доставки
    private lazy var timeCollection = TimeCollectionView() // Коллекция со временем
    private lazy var paymentLabel = DeliveryVCLabel(title: "Оплата") // Оплата
    private lazy var paymentTableView = PreferredPaymentMethodTableView(preferredPaymentMethod) // Коллекция с методами оплаты
    private lazy var orderDetailsView = DodoCoinsView(title: "Доставка", value: "Бесплатно", textColor: AppColors.grayFont) // Блок с доставкой
    private lazy var totalPriceView = OrderTotalPriceView() // Общая стоимость заказа
    private lazy var payButton = PaymentButtonView(preferredPaymentMethod) // Кнопка оплатить

    private lazy var addressStackView = DeliveryCustomStackView(addressLabel, addressTableView)
    private lazy var deliveryTimeStackView = DeliveryCustomStackView(timeLabel, timeCollection)

    private lazy var paymentMethodStackView = DeliveryCustomStackView(paymentLabel, paymentTableView)

    private lazy var tablesStackView = DeliveryCustomStackView(headerView, addressStackView, deliveryTimeStackView, paymentMethodStackView, spacing: 30)

    private lazy var orderDetailsStackView = DeliveryCustomStackView(orderDetailsView, totalPriceView, payButton)

    private lazy var contentStackView = DeliveryCustomStackView(tablesStackView, UIView(), orderDetailsStackView, spacing: 0)

    // MARK: - Other properties
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    private var preferredPaymentMethod: PaymentMethod = .cbp

    private let storage: DataStorage

    var onDismissButtonTapped: (() -> Void)?
    var onShowChooseAddress: (() -> Void)?
    var onShowChoosePaymentMethod: (() -> Void)?
    var onShowFinalVC: (() -> Void)?

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
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
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
    }

    func setupContentStackViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
            orderDetailsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomInset),

        ])
    }
}

// MARK: - Setup Actions
private extension DeliveryVC {
    func setupActions() {
        setupHeaderViewAction()
        setupAddressTableViewAction()
        setupTimeCollectionAction()
        setupPaymentTableView()
        setupPayButtonActions()
    }

    func setupHeaderViewAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            onDismissButtonTapped?()
        }
    }

    func setupAddressTableViewAction() {
        addressTableView.onCellSelected = { [weak self] in
            guard let self else { return }
            onShowChooseAddress?()
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
            onShowChoosePaymentMethod?()
        }
    }

    func setupPayButtonActions() {
        payButton.onPayButtonTapped = { [weak self] in
            guard let self else { return }
            storage.configureOrder()
            guard let order = storage.getOrderFromStorage() else { print("We have no order"); return }
            setActiveOrderToUserDefaults(order)
            onShowFinalVC?()
        }
    }
}

// MARK: - Supporting methods
private extension DeliveryVC {
    // Отправляет в UserDefaults инфу, что есть активный заказ
    func setActiveOrderToUserDefaults(_ order: Order) {
        UserDefaults.standard.sendOrder(order)
    }
}
