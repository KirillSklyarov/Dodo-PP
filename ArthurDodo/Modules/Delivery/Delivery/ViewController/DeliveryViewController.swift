import UIKit
import ActivityIndicatorSPM

protocol DeliveryViewControllerInput: BaseViewControllerInput where inputData == DeliveryData {
}

final class DeliveryViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .delivery) // Заголовок с кнопкой
    private lazy var addressLabel = DeliveryVCLabel(title: "Адрес доставки") // Адрес доставки
    private lazy var addressTableView = AddressTableView() // Таблица с адресом
    private lazy var timeLabel = DeliveryVCLabel(title: "Время доставки") // Время доставки
    private lazy var timeCollection = TimeCollectionView() // Коллекция со временем
    private lazy var paymentLabel = DeliveryVCLabel(title: "Оплата") // Оплата
    private lazy var paymentTableView = PreferredPaymentMethodTableView() // Коллекция с методами оплаты
    private lazy var orderDetailsView = DodoCoinsView(title: "Доставка", value: "Бесплатно", textColor: AppColors.grayFont) // Блок с доставкой
    private lazy var totalPriceView = OrderTotalPriceView() // Общая стоимость заказа
    private lazy var payButton = PaymentButtonView() // Кнопка оплатить

    private lazy var contentStackView = configureStackView()

    private lazy var activityIndicator = ActivityIndicatorSPM.AppActivityIndicator()

    // MARK: - Other Properties
    let output: any DeliveryViewControllerOutput

    // MARK: - Init
    init(output: any DeliveryViewControllerOutput) {
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
}

// MARK: - DeliveryViewControllerInput
extension DeliveryViewController: DeliveryViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    func showLoading() {
        activityIndicator.startAnimating()
        isShowContent(false)
    }

    func configure(with data: DeliveryData) {
        activityIndicator.stopAnimating()
        updateUI(with: data)
        isShowContent(true)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }

    func updateAddress(_ addressName: String) {
        addressTableView.updateUI(with: addressName)
        output.sendAction(.newAddressChosen(addressName))
    }

    func updatePaymentMethodUI(_ paymentMethod: PaymentMethod) {
        paymentTableView.updateUI(with: paymentMethod)
        payButton.updateUI(with: paymentMethod)
    }
}

// MARK: - Setup UI
private extension DeliveryViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView, activityIndicator)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
        setupActivityIndicatorLayout()
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints(isSafeArea: true, insets: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
}

// MARK: - Setup Actions
private extension DeliveryViewController {
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
            output.sendAction(.dismissButtonTapped)
        }
    }

    func setupAddressTableViewAction() {
        addressTableView.onCellSelected = { [weak self] in
            guard let self else { return }
            output.sendAction(.addressCellTapped)
        }
    }

    func setupTimeCollectionAction() {
        timeCollection.onDeliveryTimeSelected = { [weak self] time in
            guard let self else { return }
            output.sendAction(.deliveryTimeSelected(time))
        }
    }

    func setupPaymentTableView() {
        paymentTableView.onCellSelected = { [weak self] in
            guard let self else { return }
            output.sendAction(.paymentMethodCellTapped)
        }
    }

    func setupPayButtonActions() {
        payButton.onPayButtonTapped = { [weak self] in
            guard let self else { return }
            output.sendAction(.payButtonTapped)
        }
    }
}

// MARK: - Supporting methods
private extension DeliveryViewController {
    func isShowContent(_ bool: Bool) {
        contentStackView.alpha = bool ? 1 : 0
    }

    func updateUI(with data: DeliveryData) {
        guard let mainAddressName = data.mainAddressName,
              let cartPrice = data.cartPrice else { return }
        updateAddress(mainAddressName)
        updatePaymentMethodUI(data.preferredPaymentMethod)
        updateCartPriceView(cartPrice)
    }

    func updateAddressUI(_ mainAddressName: String) {
        addressTableView.updateUI(with: mainAddressName)
    }

    func updateCartPriceView(_ totalPrice: Int) {
        totalPriceView.updateUI(with: totalPrice)
    }
}
