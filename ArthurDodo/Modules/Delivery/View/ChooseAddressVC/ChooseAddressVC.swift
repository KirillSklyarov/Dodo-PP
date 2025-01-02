import UIKit
import Combine

final class ChooseAddressVC: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .chooseAddress) // Заголовок с кнопкой
    private lazy var addressTableView = DeliveryAddressListTableView()

    // MARK: - Presenter
    private let viewModel: ChooseAddressViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: ChooseAddressViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.removeAll()
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        dataBinding()
        
        viewModel.initialize()
    }
}

// MARK: - ChooseAddressVCProtocol
extension ChooseAddressVC: ChooseAddressVCProtocol {
    // Отдаем viewModel
    func getViewModel() -> ChooseAddressViewModelProtocol {
        viewModel
    }

    // Обновляем таблицу с адресами
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
            viewModel.sendAction(.dismissButtonTapped)
        }
    }

    // Настраиваем action: нажатие на ячейку
    func setupAddressTableViewActions() {
        addressTableView.onAddressCellTapped = { [weak self] addressName in
            guard let self else { return }
            viewModel.sendAction(.addressCellTapped(addressName))
        }

        // Настраиваем action: нажатие на редактирование адреса
        addressTableView.onEditAddressButtonTapped = { [weak self] indexPath in
            guard let self else { return }
            viewModel.sendAction(.editAddressCellTapped(indexPath))
        }

        // Настраиваем action: переход на экран добавления нового адреса
        addressTableView.onAddNewAddressCellTapped = { [weak self] in
            guard let self else { return }
            viewModel.sendAction(.addNewAddressButtonTapped)
        }
    }
}

// MARK: - Data Binding
private extension ChooseAddressVC {
    func dataBinding() {
        viewModel.addressesPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addresses in
                guard let self else { return }
                updateUI(addresses)
            }
            .store(in: &cancellables)
    }
}
