import UIKit

final class AddNewAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var mapView = MapView()
    private lazy var addressView = AddAddressView()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapView, addressView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -5
        return stackView
    }()
    private lazy var dismissButton = DismissButtonView(isChevron: true)

    // MARK: - Properties
    private var newAddress: Address?
    private var mainAddress: Address?

    private let leftInset: CGFloat = 20

    private let storage: DataStorage

    var onDismissButtonTapped: (() -> Void)?

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
        updateUIWithData()
        setupActions()

        getMainAddressFromStorage()
        configNewAddress()
    }
}

// MARK: - Public methods
extension AddNewAddressViewController {
    func updateUIWithData() {
        guard let newAddress else { print("We have no address to edit"); return }
        print(newAddress)
//         addressContainerView.updateUIWithAddress(newAddress)
    }

    func getAddressToEdit(_ addressToEdit: Address) {
        self.newAddress = addressToEdit
        getCoord()
    }

    // Запрашиваем координаты у хранилища и находим место на карте по ним
    func getMainAddressFromStorage() {
        mainAddress = storage.getMainAddress()
        getCoord()
    }
}

// MARK: - Supporting methods
private extension AddNewAddressViewController {
    // Метод находит координаты по адресу и центрирует карту по ним
    func getCoord() {
        guard let shortAddress = newAddress?.cityStreetHouse else { print("We have no address"); return }
        mapView.getCoordinates(from: shortAddress)
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

    // Настраиваем кнопку Сохранить
    func setupSaveButtonAction() {
        addressView.onSaveButtonTapped = { [weak self] in
            print(self?.newAddress)
        }
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] address in
            self?.newAddress?.cityStreetHouse = address
            self?.addressView.updateBasicAddress(address)
        }
    }

    func configNewAddress(_ shortAddress: String = "") {
        let countOfAddresses = storage.getAddresses()
        print(countOfAddresses)

//        newAddress = Address(userId: mainAddress?.userId, addressId: <#T##String#>, isMain: <#T##Bool#>, name: <#T##String#>, cityStreetHouse: <#T##String#>)
    }
}
