import UIKit

protocol AddressViewProtocol: AnyObject {
    func showAddressOnMap(_ address: Address)
    func updateAddress(_ addresses: [Address])
}

final class AddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var addressHeaderView = AddressHeaderView()
    private lazy var mapView = MapView(isTrackingButtonHidden: true)
    private lazy var addressView = DeliveryAddressView()
    private lazy var contentStack = AppStackView([mapView, addressView], axis: .vertical, spacing: -10)

    // MARK: - Properties
    let presenter: AddressPresenterProtocol

    // MARK: - Init
    init(presenter: AddressPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("AddressViewController deinit")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        presenter.viewDidLoad()
    }

    // Когда экран опять появляется (после закрытия предыдущих, то мы обновляем данные из хранилища)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
    }
}

// MARK: - Setup UI
private extension AddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack, addressHeaderView)
        setupConstraints()
        setupMapView()
    }

    func setupMapView() {
        mapView.isUserInteractionEnabled = false
    }

    func setupConstraints() {
        contentStack.setLocalConstraints(top: 0, left: 0, right: 0)
        contentStack.setLocalConstraints(isSafeArea: true, bottom: 0)

        addressHeaderView.setLocalConstraints(isSafeArea: true, top: 10, left: 20, right: 20)
    }
}

// MARK: - Setup Actions
private extension AddressViewController {
    func setupActions() {
        setupAddressHeaderAction()
        setupAddressViewAction()
    }

    func setupAddressHeaderAction() {
        addressHeaderView.onDismissButtonTapped = { [weak self] in
            self?.presenter.onDismissButtonTapped?()
        }
    }

    func setupAddressViewAction() {
        // Нажатие на кнопку редактирования адреса
        addressView.onEditAddressCellTapped = { [weak self] address in
            self?.presenter.setEditingAddressToStorage(address)
        }

        // Отрабатываем нажатие на адрес
        addressView.onAddressCellTapped = { [weak self] address in
            guard let self else { return }
            presenter.addressTapped(address)
        }

        // Нажатие на кнопку "+Новый адрес"
        addressView.onAddNewAddressButtonTapped = { [weak self] in
            self?.presenter.onShowAddNewAddressVC?()
        }

        addressView.onDeliveryButtonTapped = { [weak self] in
            self?.presenter.onDeliveryButtonTapped?()
        }
    }
}

// MARK: - AddressViewProtocol
extension AddressViewController: AddressViewProtocol {
    // Двигаем карту на главный адрес
    func showAddressOnMap(_ address: Address) {
        mapView.showAddressOnMap(address)
    }

    // Обновляем список адресов
    func updateAddress(_ addresses: [Address]) {
        addressView.getAddresses(addresses)
    }
}
