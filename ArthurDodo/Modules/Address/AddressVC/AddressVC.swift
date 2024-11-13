import UIKit

final class AddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var addressHeaderStackView = AddressHeaderView()
    private lazy var mapView = MapView(isPinHidden: false, isTrackingButtonHidden: true)
    private lazy var addressView = DeliveryAddressView()
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapView, addressView])
        stackView.axis = .vertical
        stackView.spacing = -10
        return stackView
    }()

    // MARK: - Other Properties
    private var mainAddress: Address?
    private var addresses: [Address]?

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

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchData()
    }
}

// MARK: - Fetch data from Network
extension AddressViewController {
    func fetchData() {
        if storage.isAddressesEmpty() {
            fetchAddresses()
        } else {
            getAddressFromStorage()
        }
        moveMapToMainAddress()
    }

    // Запрашиваем данные с сервера и когда все получено, то просто забираем с него данные
    func fetchAddresses() {
        storage.fetchUserAddresses()
        storage.onDataFetchedSuccessfully = { [weak self] in
            guard let self else { return }
            getAddressFromStorage()
        }
    }

    func getAddressFromStorage() {
        mainAddress = storage.getMainAddress()
        addresses = storage.getAddresses()
        passAddressToNextScreen()
    }

    // Передаем адреса на следующий вью
    func passAddressToNextScreen() {
        guard let addresses else {print("We have no addresses"); return }
        addressView.getAddresses(addresses)
    }
}

// MARK: - Setup UI
private extension AddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStack, addressHeaderStackView)
        setupConstraints()
        setupMapView()
    }

    func setupMapView() {
        mapView.isUserInteractionEnabled = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Setup Actions
private extension AddressViewController {
    func setupActions() {
        setupAddressHeaderAction()
        setupAddressViewAction()
    }

    func setupAddressHeaderAction() {
        addressHeaderStackView.onDismissButtonTapped = { [weak self] in
            self?.router.dismissCurrentVC()
        }
    }

    func setupAddressViewAction() {
        // Нажатие на кнопку редактирования адреса
        addressView.onEditAddressCellTapped = { [weak self] address in
            self?.router.showEditAddressVC(address)
        }

        // Нажатие на кнопку "+ Новый адрес"
        addressView.onAddNewAddressButtonTapped = { [weak self] in
            self?.router.showAddNewAddressVC()
        }
    }
}

// MARK: - Supporting methods
private extension AddressViewController {
    // Двигаем карту на главный адрес
    func moveMapToMainAddress() {
        guard let mainAddress else {print("We have no main address"); return }
        let shortAddress = mainAddress.cityStreetHouse
        print("shortAddress \(shortAddress)")
        mapView.getCoordinates(from: shortAddress)
    }
}
