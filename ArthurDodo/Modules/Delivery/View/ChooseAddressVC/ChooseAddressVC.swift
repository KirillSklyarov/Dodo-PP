import UIKit

protocol ChooseAddressVCProtocol: AnyObject {
    func updateUI(_ addresses: [Address])
}

final class ChooseAddressVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .chooseAddress) // Заголовок с кнопкой
    private lazy var addressTableView = DeliveryAddressListTableView()

    // MARK: - Presenter
    let presenter: ChooseAddressPresenterProtocol

    // MARK: - Init
    init(presenter: ChooseAddressPresenterProtocol) {
        self.presenter = presenter
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
        presenter.viewDidLoad()
    }
}

// MARK: - ChooseAddressVCProtocol
extension ChooseAddressVC: ChooseAddressVCProtocol {
    func updateUI(_ addresses: [Address]) {
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
            presenter.dismissButtonTapped()
        }
    }

    // Настраиваем action: нажатие на ячейку
    func setupAddressTableViewActions() {
        addressTableView.onAddressCellTapped = { [weak self] addressName in
            guard let self else { return }
            presenter.addressCellTapped(addressName)
        }

        // Настраиваем action: нажатие на редактирование адреса
        addressTableView.onEditAddressButtonTapped = { [weak self] indexPath in
            guard let self else { return }
            presenter.editAddressCellTapped(indexPath)
        }

        // Настраиваем action: переход на экран добавления нового адреса
        addressTableView.onAddNewAddressCellTapped = { [weak self] in
            guard let self else { return }
            presenter.addNewAddressButtonTapped()
        }
    }
}
