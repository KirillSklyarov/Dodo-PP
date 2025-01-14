import UIKit

protocol AddressViewControllerInput: BaseViewControllerInput where inputData == [Address] {
    func showAddressOnMap()
}

final class AddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var addressHeaderView = AddressHeaderView()
    private lazy var mapView = MapView(isTrackingButtonHidden: true)
    private lazy var addressView = DeliveryAddressView()
    private lazy var contentStack = AppStackView([mapView, addressView], axis: .vertical, spacing: -10)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Output
    let output: any AddressViewControllerOutput

    // MARK: - Init
    init(output: any AddressViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("AddressViewController deinit")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }

    // Когда экран опять появляется (после закрытия предыдущих, то мы обновляем данные из хранилища)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewLoaded()
        print(#function)
    }
}

// MARK: - AddressViewControllerInput
extension AddressViewController: AddressViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    func showLoading() {
        activityIndicator.startAnimating()
        isShowContent(false)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }

    func configure(with data: [Address]) {
        activityIndicator.stopAnimating()
        updateAddress(data)
        isShowContent(true)
    }

    // Двигаем карту на главный адрес
    func showAddressOnMap() {
        guard let mainAddress = output.getMainAddress() else { print("Main address not found"); return }
        mapView.showAddressOnMap(mainAddress)
    }
}

// MARK: - Setup UI
private extension AddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack, addressHeaderView, activityIndicator)
        setupConstraints()
        setupMapView()
    }

    func setupMapView() {
        mapView.isUserInteractionEnabled = false
    }

    func setupConstraints() {
        contentStack.setLocalConstraints(top: 0, left: 0, right: 0)
        contentStack.setLocalConstraints(isSafeArea: true, bottom: 0)

        addressHeaderView.setLocalConstraints(isSafeArea: true, top: 10, left: 20, right: 20)

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension AddressViewController {
    func setupActions() {
        setupAddressHeaderAction()
        setupAddressViewAction()
    }

    func setupAddressHeaderAction() {
        addressHeaderView.onDismissButtonTapped = { [weak self] in
            self?.output.sendAction(.dismissButtonTapped)
        }
    }

    func setupAddressViewAction() {
        // Нажатие на кнопку редактирования адреса
        addressView.onEditAddressCellTapped = { [weak self] address in
            self?.output.sendAction(.editAddressTapped(address))
        }

        // Отрабатываем нажатие на адрес
        addressView.onAddressCellTapped = { [weak self] address in
            self?.output.sendAction(.addressSelected(address))
        }

        // Нажатие на кнопку "+Новый адрес"
        addressView.onAddNewAddressButtonTapped = { [weak self] in
            self?.output.sendAction(.addNewAddressTapped)
        }

        // Нажатие на кнопку "Доставить сюда"
        addressView.onDeliveryButtonTapped = { [weak self] in
            self?.output.sendAction(.deliveryButtonTapped)
        }
    }
}

// MARK: - Supporting methods
extension AddressViewController {
    // Обновляем список адресов
    func updateAddress(_ addresses: [Address]) {
        addressView.getAddresses(addresses)
        showAddressOnMap()
    }

    // Показываем или скрываем контент
    func isShowContent(_ show: Bool) {
        contentStack.alpha = show ? 1 : 0
    }
}
