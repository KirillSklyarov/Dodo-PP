import UIKit

final class EditAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var mapView = EditAddressMapView()
    private lazy var addressContainerView = EditAddressView()
    private lazy var contentStackView = AppStackView([mapView, addressContainerView], axis: .vertical, spacing: -5, distribution: .fillEqually)
    private lazy var dismissButton = AppDismissButtonView(type: .chevron)

    // MARK: - Other properties
    private var addressToEdit: Address?
    private let storage: DataStorage

    private let leftInset: CGFloat = 20

    var onDismissButtonTapped: (() -> Void)?
    var onSaveButtonTapped: (() -> Void)?

    // MARK: - Init
    init(_ addressToEdit: Address, storage: DataStorage) {
        self.storage = storage
        self.addressToEdit = addressToEdit
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
    }
}

// MARK: - Supporting methods
private extension EditAddressViewController {
    func updateUIWithData() {
        updateAddressDetailsView()
        showAddressOnMap()
    }

    func updateAddressDetailsView() {
        guard let addressToEdit else { print("We have no address to edit"); return }
        addressContainerView.updateUIWithAddress(addressToEdit)
    }


    func showAddressOnMap() {
        guard let addressToEdit else { print("We have no address to edit"); return }
        mapView.showAddressOnMap(addressToEdit)
    }
}

// MARK: - Setup UI
private extension EditAddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
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
        setupMapViewAction()
    }

    // Отрабатываем нажатие на кнопку сохранить новый адрес
    func setupAddressContainerViewAction() {
        addressContainerView.onSaveAddressTapped = { [weak self] in
            guard let self,
                  let addressToEdit else { print("We have no self"); return }
            storage.updateAddressesAfterEdition(correctAddress: addressToEdit)
            onSaveButtonTapped?()
        }
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] shortAddress in
            self?.addressToEdit?.cityStreetHouse = shortAddress
            self?.addressContainerView.updateShortAddress(shortAddress)
        }
    }

    // Настраиваем кнопку Закрыть
    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }
}
