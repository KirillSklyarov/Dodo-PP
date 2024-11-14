import UIKit

final class EditAddressViewController: UIViewController {

    // MARK: - Properties
    private var addressToEdit: Address?
    private let leftInset: CGFloat = 20

    // MARK: - UI Properties
    private lazy var mapView = MapView()
    private lazy var addressContainerView = EditAddressView()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapView, addressContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -5
        return stackView
    }()
    private lazy var dismissButton = DismissButtonView(isChevron: true)

    private let storage: DataStorage
    private let router: Router

    // MARK: - Init
    init(_ addressToEdit: Address, storage: DataStorage, router: Router) {
        self.storage = storage
        self.router = router
        super.init(nibName: nil, bundle: nil)
        getAddressToEdit(addressToEdit)
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
    }
}

// MARK: - Public methods
extension EditAddressViewController {
    func updateUIWithData() {
        guard let addressToEdit else { print("We have no address to edit"); return }
        print(addressToEdit)
        addressContainerView.updateUIWithAddress(addressToEdit)
    }

    func getAddressToEdit(_ addressToEdit: Address) {
        self.addressToEdit = addressToEdit
        getCoord()
    }
}

// MARK: - Supporting methods
extension EditAddressViewController {
    private func getCoord() {
        guard let shortAddress = addressToEdit?.cityStreetHouse else { print("We have no address"); return }
        mapView.getCoordinates(from: shortAddress)
    }
}

// MARK: - Setup UI
private extension EditAddressViewController {
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
private extension EditAddressViewController {
    func setupActions() {
        setupAddressContainerViewAction()
        setupDismissButtonAction()
        setupSaveButtonAction()
        setupMapViewAction()
    }

    // Отрабатываем нажатие на кнопку сохранить новый адрес
    func setupAddressContainerViewAction() {
        addressContainerView.onSaveAddressTapped = { [weak self] address in
            guard let self else { print("We have no self"); return }
            storage.sendNewAddressToServer(addressToEdit: address)
        }
    }

    // Настраиваем кнопку Сохранить
    func setupSaveButtonAction() {
        guard let addressToEdit else { print("We have no address to edit"); return }
        addressContainerView.setupSaveButtonAction(addressToEdit)
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] address in
            self?.addressContainerView.updateBasicAddress(address)
        }
    }

    // Настраиваем кнопку Закрыть
    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.router.dismissCurrentVC()
        }
    }
}
