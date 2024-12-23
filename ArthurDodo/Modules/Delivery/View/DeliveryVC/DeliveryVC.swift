import UIKit
import Combine

protocol DeliveryViewProtocol: AnyObject {
    func updateAddressUI(_ mainAddressName: String)
    func updatePaymentMethodUI(_ paymentMethod: PaymentMethod)
    func updateCartPriceView(_ totalPrice: Int)
    func getViewModel() -> DeliveryViewModelProtocol
}

final class DeliveryVC: UIViewController {

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

    // MARK: - Other Properties
    private let viewModel: DeliveryViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: DeliveryViewModelProtocol) {
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
}

// MARK: - DeliveryViewProtocol
extension DeliveryVC: DeliveryViewProtocol {
    func getViewModel() -> DeliveryViewModelProtocol {
        viewModel
    }

    func updateAddress(_ addressName: String) {
        addressTableView.updateUI(with: addressName)
        viewModel.sendNewAddressToStorage(addressName)
    }

    func updatePaymentMethodUI(_ paymentMethod: PaymentMethod) {
        paymentTableView.updateUI(with: paymentMethod)
        payButton.updateUI(with: paymentMethod)
    }

    func updateAddressUI(_ mainAddressName: String) {
        addressTableView.updateUI(with: mainAddressName)
    }

    func updateCartPriceView(_ totalPrice: Int) {
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
            viewModel.dismissButtonTapped()
        }
    }

    func setupAddressTableViewAction() {
        addressTableView.onCellSelected = { [weak self] in
            guard let self else { return }
            viewModel.addressCellTapped()
        }
    }

    func setupTimeCollectionAction() {
        timeCollection.onDeliveryTimeSelected = { [weak self] time in
            guard let self else { return }
            viewModel.deliveryTimeSelected(time)
        }
    }

    func setupPaymentTableView() {
        paymentTableView.onCellSelected = { [weak self] in
            guard let self else { return }
            viewModel.paymentMethodCellTapped()
        }
    }

    func setupPayButtonActions() {
        payButton.onPayButtonTapped = { [weak self] in
            guard let self else { return }
            viewModel.payButtonTapped()
        }
    }
}

// MARK: - Data Binding
extension DeliveryVC {
    // Настраиваем байндинги: адрес, метод оплаты и общую стоимость заказа
    func dataBinding() {
        viewModel.mainAddressPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] address in
                guard let self else { return }
                updateAddress(address)
            }
            .store(in: &cancellables)

        viewModel.preferredPaymentMethodPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] paymentMethod in
                guard let self else { return }
                updatePaymentMethodUI(paymentMethod)
            }
            .store(in: &cancellables)

        viewModel.cartPricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                guard let self else { return }
                updateCartPriceView(price)
            }
            .store(in: &cancellables)
    }
}
