import UIKit

final class ChooseAddressVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationHeaderView(title: "Адреса доставки") // Заголовок с кнопкой
    private lazy var addressTableView = DeliveryAddressListTableView()

    // MARK: - Other Properties
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10
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
    func fetchData() {
        if storage.isAddressesEmpty() {
            storage.fetchUserAddresses()
            storage.onDataFetchedSuccessfully = { [weak self] in
                guard let self else { return }
                getAddressesAndUpdateUI()
            }
        } else {
            getAddressesAndUpdateUI()
        }
    }

    func getAddressesAndUpdateUI() {
        addresses = storage.getAddresses()
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
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
        ])
    }

    func setupAddressTableViewLayout() {
        NSLayoutConstraint.activate([
            addressTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: topInset),
            addressTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            addressTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
        ])
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
