import UIKit

final class DeliveryVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .delivery) // Заголовок с кнопкой
    private lazy var addressLabel = DeliveryVCLabel(title: "Адрес доставки") // Адрес доставки
    private lazy var addressTableView = AddressTableView() // Таблица с адресом
    private lazy var timeLabel = DeliveryVCLabel(title: "Время доставки") // Время доставки
    private lazy var timeCollection = TimeCollectionView() // Коллекция со временем
    private lazy var paymentLabel = DeliveryVCLabel(title: "Оплата") // Оплата
    private lazy var paymentTableView = PreferredPaymentMethodTableView(preferredPaymentMethod) // Коллекция с методами оплаты
    private lazy var orderDetailsView = DodoCoinsView(title: "Доставка", value: "Бесплатно", textColor: AppColors.grayFont) // Блок с доставкой
    private lazy var totalPriceView = OrderTotalPriceView() // Общая стоимость заказа
    private lazy var payButton = PaymentButtonView(preferredPaymentMethod) // Кнопка оплатить

    private lazy var contentStackView = configureStackView()

    // MARK: - Other properties
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
        guard let mainAddressName = storage.getMainAddress()?.name else { print("Error: No main address"); return }
        addressTableView.updateUI(with: mainAddressName)
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

    func configureStackView() -> UIStackView {
        let addressStackView = AppStackView([addressLabel, addressTableView], axis: .vertical, spacing: 10)
        let deliveryTimeStackView = AppStackView([timeLabel, timeCollection], axis: .vertical, spacing: 10)

        let paymentMethodStackView = AppStackView([paymentLabel, paymentTableView], axis: .vertical, spacing: 10)

        let tablesStackView = AppStackView([headerView, addressStackView, deliveryTimeStackView, paymentMethodStackView], axis: .vertical, spacing: 30)

        let orderDetailsStackView = AppStackView([orderDetailsView, totalPriceView, payButton], axis: .vertical, spacing: 10)

        let contentStackView = AppStackView([tablesStackView, UIView(), orderDetailsStackView], axis: .vertical)

        return contentStackView
    }

    func setupLayout() {
        setupContentStackViewLayout()
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints(isSafeArea: true, insets: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
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
