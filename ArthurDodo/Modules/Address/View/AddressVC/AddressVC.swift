import UIKit
import Combine

protocol AddressViewProtocol: AnyObject {
    func showAddressOnMap(_ address: Address?)
    func updateAddress(_ addresses: [Address])
    func getViewModel() -> any AddressViewModelProtocol 
}

final class AddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var addressHeaderView = AddressHeaderView()
    private lazy var mapView = MapView(isTrackingButtonHidden: true)
    private lazy var addressView = DeliveryAddressView()
    private lazy var contentStack = AppStackView([mapView, addressView], axis: .vertical, spacing: -10)

    // MARK: - Properties
    private let viewModel: any AddressViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: any AddressViewModelProtocol) {
        self.viewModel = viewModel
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
        dataBinding()
    }

    // Когда экран опять появляется (после закрытия предыдущих, то мы обновляем данные из хранилища)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initialize()
        print(#function)
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
            self?.viewModel.sendAction(.dismissButtonTapped)
        }
    }

    func setupAddressViewAction() {
        // Нажатие на кнопку редактирования адреса
        addressView.onEditAddressCellTapped = { [weak self] address in
            self?.viewModel.sendAction(.editAddressTapped(address))
        }

        // Отрабатываем нажатие на адрес
        addressView.onAddressCellTapped = { [weak self] address in
            guard let self else { return }
            viewModel.sendAction(.addressSelected(address))
        }

        // Нажатие на кнопку "+Новый адрес"
        addressView.onAddNewAddressButtonTapped = { [weak self] in
            self?.viewModel.sendAction(.addNewAddressTapped)
        }

        // Нажатие на кнопку "Доставить сюда"
        addressView.onDeliveryButtonTapped = { [weak self] in
            self?.viewModel.sendAction(.deliveryButtonTapped)
        }
    }
}

// MARK: - AddressViewProtocol
extension AddressViewController: AddressViewProtocol {
    // Отдаем viewModel
    func getViewModel() -> any AddressViewModelProtocol {
        viewModel
    }

    // Двигаем карту на главный адрес
    func showAddressOnMap(_ address: Address?) {
        guard let address else { return }
        mapView.showAddressOnMap(address)
    }

    // Обновляем список адресов
    func updateAddress(_ addresses: [Address]) {
        addressView.getAddresses(addresses)
    }
}

// MARK: - Data binging
private extension AddressViewController {
    func dataBinding() {
        viewModel.addressesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addresses in
                guard let self else { return }
                updateAddress(addresses)
            }
            .store(in: &cancellables)

        viewModel.mainAddressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] address in
                guard let self else { return }
                showAddressOnMap(address)
            }
            .store(in: &cancellables)
    }
}
