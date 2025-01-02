import UIKit
import Combine

protocol EditAddressViewProtocol: AnyObject {
    func getViewModel() -> any EditAddressViewModelProtocol
    func updateAddress(_ addressToEdit: Address?)
}

final class EditAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var mapView = EditAddressMapView()
    private lazy var addressContainerView = EditAddressView()
    private lazy var contentStackView = AppStackView([mapView, addressContainerView], axis: .vertical, spacing: -5, distribution: .fillEqually)
    private lazy var dismissButton = AppDismissButtonView(type: .chevron)

    // MARK: - ViewModel
    private let viewModel: any EditAddressViewModelProtocol
    private var cancellations = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: any EditAddressViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellations.removeAll()
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        dataBinding()
        viewModelSetup()
    }
}

// MARK: - EditAddressViewProtocol
extension EditAddressViewController: EditAddressViewProtocol {
    func getViewModel() -> any EditAddressViewModelProtocol {
        viewModel
    }

    // Обновляет адрес на вью
    func updateAddress(_ addressToEdit: Address?) {
        guard let addressToEdit else { print("We have no address"); return }
        updateAddressDetailsView(addressToEdit)
        showAddressOnMap(addressToEdit)
        updateShortAddress(addressToEdit)
    }

    private func updateShortAddress(_ address: Address) {
        let shortAddress = address.cityStreetHouse
        addressContainerView.updateShortAddress(shortAddress)
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
        dismissButton.setLocalConstraints(isSafeArea: true, top: 0, left: 20)
        contentStackView.setLocalConstraints(isSafeArea: true, bottom: 0, left: 0, right: 0)
        contentStackView.setLocalConstraints(isSafeArea: false, top: 0)
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
            guard let self else { print("We have no self"); return }
            viewModel.sendAction(.saveButtonTapped)
        }
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] shortAddress in
            self?.viewModel.sendAction(.mapIsMoving(shortAddress))
        }
    }

    // Настраиваем кнопку Закрыть
    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.viewModel.sendAction(.dismissButtonTapped)
        }
    }
}

// MARK: - Data binding
private extension EditAddressViewController {
    func dataBinding() {
        viewModel.addressToEditPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addressToEdit in
                guard let self else { print("We have no self"); return }
                updateAddress(addressToEdit)
            }
            .store(in: &cancellations)
    }
}

// MARK: - Supporting methods
private extension EditAddressViewController {
    // Загружаем viewModel после того как карта загрузилась вся
    func viewModelSetup() {
        mapView.onMapLoaded = { [weak self] in
            self?.viewModel.initialize()
        }
    }

    // Обновляет адрес на вью
    func updateAddressDetailsView(_ addressToEdit: Address) {
        addressContainerView.updateUIWithAddress(addressToEdit)
    }

    // Показывает адрес на карте
    func showAddressOnMap(_ addressToEdit: Address) {
        mapView.showAddressOnMap(addressToEdit)
    }
}
