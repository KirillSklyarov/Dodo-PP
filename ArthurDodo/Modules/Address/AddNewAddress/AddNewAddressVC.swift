import UIKit

final class AddNewAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var mapView = AddAddressMapView()
    private lazy var addressView = AddAddressView()
    private lazy var contentStackView = AppStackView([mapView, addressView], axis: .vertical, spacing: -5, distribution: .fillEqually)
    private lazy var dismissButton = DismissButtonView(isChevron: true)

    // MARK: - Properties
    private let leftInset: CGFloat = 20

    private var mainAddress: Address?
    private let storage: DataStorage

    var onDismissButtonTapped: (() -> Void)?
    var onSaveNewAddressButtonTapped: (() -> Void)?

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
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
        fetchData()
    }
}

// MARK: - Fetch Data
private extension AddNewAddressViewController {
    // Запрашиваем основной адрес у хранилища и показываем его на карте
    func fetchData() {
        mainAddress = storage.getMainAddress()
        showMainAddressOnMap() // Показываем основной адрес на карте
        updateUIWithData() // Обновляем таблицу с данными адреса (город, дом и проч.)
    }
}

// MARK: - Public methods
extension AddNewAddressViewController {
    func updateUIWithData() {
        guard let mainAddress else { print("We have no address to edit"); return }
        addressView.updateUIWithAddress(mainAddress)
    }
}

// MARK: - Supporting methods
private extension AddNewAddressViewController {
    // Метод находит координаты по адресу и центрирует карту по ним
    func showMainAddressOnMap() {
        guard let shortAddress = mainAddress?.cityStreetHouse else { print("We have no address"); return }
        mapView.showAddressOnMap(shortAddress)
    }
}

// MARK: - Setup UI
private extension AddNewAddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStackView, dismissButton)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
        ])
    }
}

// MARK: - Setup Actions
private extension AddNewAddressViewController {
    func setupActions() {
        setupDismissButtonAction()
        setupSaveButtonAction()
        setupMapViewAction()
    }

    // Настраиваем кнопку Закрыть
    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }

    // Настраиваем кнопку Сохранить - формируем новый адрес и отправляем его на сервер
    func setupSaveButtonAction() {
        addressView.onSaveButtonTapped = { [weak self] newShortAddress in
            guard let self else { return }
            passNewAddressToStorage(newShortAddress)
            onSaveNewAddressButtonTapped?()
        }
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] address in
            self?.addressView.updateShortAddress(address)
        }
    }

    // Формируем из короткого адреса полный адрес и отправляем его в хранилище
    func passNewAddressToStorage(_ shortAddress: String) {
        let newAddress = castAddressFromShortAddress(shortAddress)
//        let addresses = storage.getAddresses()
//        print("addresses \(addresses.count)")
        storage.addAddress(newAddress)
    }

    // Формируем из короткого адреса полный адрес
    func castAddressFromShortAddress(_ shortAddress: String) -> Address {
        let countOfAddresses = storage.getCountOfAddresses()
        let newAddressId = "\(countOfAddresses + 1)"
        let newAddress = Address(addressId: newAddressId, isMain: false, name: shortAddress, cityStreetHouse: shortAddress, apartment: nil, floor: nil, entrance: nil, entranceCode: nil, comments: nil)
        return newAddress
    }
}
