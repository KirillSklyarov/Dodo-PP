import UIKit

protocol ChooseAddressViewInput: AnyObject {
    func setInitialState()
    func showLoading()
    func configure(with addresses: [Address])
    func showError()
}


final class ChooseAddressViewController: UIViewController, ModuleTransitionable {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .chooseAddress) // Заголовок с кнопкой
    private lazy var addressTableView = DeliveryAddressListTableView()
    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Presenter
    let output: any ChooseAddressViewControllerOutput

    // MARK: - Init
    init(output: any ChooseAddressViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - ChooseAddressViewInput
extension ChooseAddressViewController: ChooseAddressViewInput {
    // Устанавливаем начальное состояние экрана
    func setInitialState() {
        setupUI()
        setupActions()
    }

    // Убираем контент и показываем спиннер
    func showLoading() {
        isShowContent(false)
        activityIndicator.startAnimating()
    }

    func configure(with addresses: [Address]) {
        activityIndicator.stopAnimating()
        isShowContent(true)
        updateUI(addresses)
    }

    // Для показа алерта с ошибкой выключаем спиннер
    func showError() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Setup UI
private extension ChooseAddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, addressTableView, activityIndicator)

        setupLayout()
    }

    func setupLayout() {
        setupHeaderViewLayout()
        setupAddressTableViewLayout()
        setupActivityIndicatorLayout()
    }

    func setupHeaderViewLayout() {
        headerView.setLocalConstraints(isSafeArea: true, top: 0, left: 10, right: 10)
    }

    func setupAddressTableViewLayout() {
        addressTableView.setLocalConstraints(left: 10, right: 10)
        addressTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension ChooseAddressViewController {
    func setupActions() {
        setupHeaderViewAction()
        setupAddressTableViewActions()
    }

    func setupHeaderViewAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            output.sendAction(.dismissButtonTapped)
        }
    }

    // Настраиваем action: нажатие на ячейку
    func setupAddressTableViewActions() {
        addressTableView.onAddressCellTapped = { [weak self] addressName in
            guard let self else { return }
            output.sendAction(.addressCellTapped(addressName))
        }

        // Настраиваем action: нажатие на редактирование адреса
        addressTableView.onEditAddressButtonTapped = { [weak self] indexPath in
            guard let self else { return }
            output.sendAction(.editAddressCellTapped(indexPath))
        }

        // Настраиваем action: переход на экран добавления нового адреса
        addressTableView.onAddNewAddressCellTapped = { [weak self] in
            guard let self else { return }
            output.sendAction(.addNewAddressButtonTapped)
        }
    }
}

// MARK: - Supporting methods
private extension ChooseAddressViewController {
    // Обновляем таблицу с адресами
    func updateUI(_ addresses: [Address]) {
        addressTableView.updateUI(with: addresses)
    }

    // В зависимости от параметра показываем или скрываем хэдер
    func isShowContent(_ bool: Bool) {
        headerView.alpha = bool ? 1 : 0
    }
}
