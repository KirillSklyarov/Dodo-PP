import UIKit

final class ChooseAddressVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .chooseAddress) // Заголовок с кнопкой
    private lazy var addressTableView = DeliveryAddressListTableView()

    // MARK: - Other Properties
    private var addresses: [Address] = []

    private let storage: DataStorage

    var onAddressCellTapped: ((String) -> Void)?
    var onDismissButtonTapped: (() -> Void)?
    var onEditAddressCellTapped: ( (Address) -> Void)?
    var onShowAddNewAddress: (() -> Void)?

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
        fetchData()
        setupActions()
    }
}

// MARK: - Fetch Data
private extension ChooseAddressVC {
    // Получаем данные об адресе
    func fetchData() {
        getAddressesAndUpdateUI()
    }

    // Получаем данные об адресе из хранилища и обновляем таблицу
    func getAddressesAndUpdateUI() {
        addresses = storage.addressStorage.getAddresses()
        addressTableView.updateUI(with: addresses)
    }
}

// MARK: - Setup UI
private extension ChooseAddressVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, addressTableView)

        setupLayout()
    }

    func setupLayout() {
        setupHeaderViewLayout()
        setupAddressTableViewLayout()
    }

    func setupHeaderViewLayout() {
        headerView.setLocalConstraints(isSafeArea: true, top: 0, left: 10, right: 10)
    }

    func setupAddressTableViewLayout() {
        addressTableView.setLocalConstraints(left: 10, right: 10)
        addressTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
    }
}

// MARK: - Setup Actions
private extension ChooseAddressVC {
    func setupActions() {
        setupHeaderViewAction()
        setupAddressTableViewActions()
    }

    func setupHeaderViewAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            onDismissButtonTapped?()
        }
    }

    // Настраиваем action: нажатие на ячейку
    func setupAddressTableViewActions() {
        addressTableView.onAddressCellTapped = { [weak self] addressName in
            guard let self else { return }
            onAddressCellTapped?(addressName)
            onDismissButtonTapped?()
        }

        // Настраиваем action: нажатие на редактирование адреса
        addressTableView.onEditAddressButtonTapped = { [weak self] indexPath in
            guard let self else { return }
            let address = addresses[indexPath.row]
            onEditAddressCellTapped?(address)
        }

        // Настраиваем action: переход на экран добавления нового адреса
        addressTableView.onAddNewAddressCellTapped = { [weak self] in
            self?.onShowAddNewAddress?()
        }
    }
}
