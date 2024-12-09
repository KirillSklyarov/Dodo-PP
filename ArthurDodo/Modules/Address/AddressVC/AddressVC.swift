import UIKit

final class AddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var addressHeaderView = AddressHeaderView()
    private lazy var mapView = MapView(isTrackingButtonHidden: true)
    private lazy var addressView = DeliveryAddressView()
    private lazy var contentStack = AppStackView([mapView, addressView], axis: .vertical, spacing: -10)

    // MARK: - Other Properties
    private var mainAddress: Address?
    private var addresses: [Address]?

    private let storage: DataStorage

    var onDismissButtonTapped: (() -> Void)?
    var onShowEditAddressVC: ((Address) -> Void)?
    var onShowAddNewAddressVC: (() -> Void)?
    var onDeliveryButtonTapped: (() -> Void)?

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
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
        setupUI()
        setupActions()
        fetchData()
    }

    // Когда экран опять появляется (после закрытия предыдущих, то мы обновляем данные из хранилища)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAddressFromStorage()
    }
}

// MARK: - Fetch data from Network
private extension AddressViewController {
    // Если личные данные уже были загружены, то забираем из хранилища, если нет, то инициируем сетевой запрос
    func fetchData() {
        if storage.profileStorage.isUserDataLoaded() {
            getAddressFromStorage()
        } else {
            fetchAddresses()

        }
    }

    // Запрашиваем данные с сервера и когда все получено, то просто забираем с него данные
    func fetchAddresses() {
        getAddressFromStorage()
    }

    // Получаем данные из хранилища
    func getAddressFromStorage() {
        let dispatchGroup = DispatchGroup()

        // Сначала получаем все данные
        dispatchGroup.enter()
        getAddressesAndMainAddress {
            dispatchGroup.leave()
        }

        // Потом уже передаем адреса на карту
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { print("We have no self"); return }
            passAddressToNextScreen()
            showMainAddressOnMap()
        }
    }

    // Забираем данные из хранилища
    func getAddressesAndMainAddress(completion: (() -> Void)?) {
        addresses = storage.getAddresses()
        mainAddress = storage.getMainAddress()
        completion?()
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
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack, addressHeaderView)
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
            self?.onDismissButtonTapped?()
        }
    }

    func setupAddressViewAction() {
        // Нажатие на кнопку редактирования адреса
        addressView.onEditAddressCellTapped = { [weak self] address in
            self?.onShowEditAddressVC?(address)
        }

        // Когда юзер нажал на новый адрес мы показываем его на карте и ставим этот адрес как main
        addressView.onAddressCellTapped = { [weak self] address in
            guard let self else { return }
            storage.setNewMainAddress(address.name) // Устанавливаем новые главный адрес
            showAddressOnMap(address) // Показываем новый адрес на карте
        }

        // Нажатие на кнопку "+Новый адрес"
        addressView.onAddNewAddressButtonTapped = { [weak self] in
            self?.onShowAddNewAddressVC?()
        }

        addressView.onDeliveryButtonTapped = { [weak self] in
            self?.onDeliveryButtonTapped?()
        }
    }
}

// MARK: - Supporting methods
private extension AddressViewController {
    // Двигаем карту на главный адрес
    func showMainAddressOnMap() {
        if let mainAddress { showAddressOnMap(mainAddress) } else { print("Warning: No main address") }
    }

    func showAddressOnMap(_ address: Address) {
        mapView.showAddressOnMap(address)
    }
}
