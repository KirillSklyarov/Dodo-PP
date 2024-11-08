import UIKit

final class ChooseAddressVC: UIViewController {

    // MARK: - UI Properties
    private lazy var addressTableView = DeliveryAddressListTableView()

    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    var onAddressCellTapped: ((String) -> Void)?

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

    // MARK: - Init
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
        let addresses = storage.fetchedUserAddresses
        addressTableView.updateUI(with: addresses)
    }
}

// MARK: - Setup UI
private extension ChooseAddressVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(addressTableView)

        setupNavigationBar()
        setupLayout()
    }

    func setupNavigationBar() {
        navigationItem.title = "Адреса доставки"

        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        let dismissButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = AppColors.buttonOrange
        dismissButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.leftBarButtonItem = dismissButton
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            addressTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addressTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            addressTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
        ])
    }
}

// MARK: - Setup Actions
private extension ChooseAddressVC {
    func setupActions() {
        setupAddressTableViewActions()
    }

    // Настраиваем action: нажатие на ячейку
    func setupAddressTableViewActions() {
        addressTableView.onAddressCellTapped = { [weak self] addressName in
            guard let self else { return }
            onAddressCellTapped?(addressName)
            dismiss(animated: true)
        }

        // Настраиваем action: нажатие на редактирование адреса
        addressTableView.onEditAddressButtonTapped = { [weak self] indexPath in
            guard let self else { return }
            let address = storage.fetchedUserAddresses[indexPath.row]
            router.showEditAddressVC(address)
        }

        // Настраиваем action: переход на экран добавления нового адреса
        addressTableView.onAddNewAddressCellTapped = { [weak self] in
            self?.router.showAddNewAddressVC()
        }
    }

    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
}
