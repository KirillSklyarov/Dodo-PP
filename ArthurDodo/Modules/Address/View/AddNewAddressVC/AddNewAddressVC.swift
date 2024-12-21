import UIKit
import Combine

// ВАЖНО: мы вызываем метод initialize у viewModel только после загрузки карты (это замыкание  mapView.onMapLoaded), тогда не прилетают ошибки при загрузке адреса
final class AddNewAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .chevron)
    private lazy var mapView = AddAddressMapView()
    private lazy var addressView = AddAddressView()
    private lazy var contentStackView = AppStackView([mapView, addressView], axis: .vertical, spacing: -5, distribution: .fill)

    // MARK: - Presenter
    let viewModel: AddNewAddressVMProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: AddNewAddressVMProtocol) {
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
        viewModelSetup()

        setupGestureToDissmissKeyboard()
    }

    // Мы начинаем флоу вью модели только после того как закончилась загрузка карты (чтобы не допустить ошибок и опережения)
    func viewModelSetup() {
        mapView.onMapLoaded = { [weak self] in
            self?.viewModel.initialize()
        }
    }
}

// MARK: - Setup UI
private extension AddNewAddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStackView, dismissButton)
        setupLayout()
    }

    func setupLayout() {
        dismissButton.setLocalConstraints(isSafeArea: true, top: 0, left: 20)
        contentStackView.setLocalConstraints(top: 0, left: 0, right: 0)
        contentStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10).withPriority(.defaultLow).isActive = true // Позволяет убирать конфликты с клавиатурой
    }
}

// MARK: - Setup Actions
private extension AddNewAddressViewController {
    func setupActions() {
        setupDismissButtonAction()
        setupSaveButtonAction()
        setupMapViewAction()
    }

    // Настраиваем кнопку Закрыть
    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.viewModel.onDismissButtonTapped?()
        }
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] address in
            self?.addressView.updateShortAddress(address)
        }
    }

    // Настраиваем кнопку Сохранить - отправляем новый адрес на сервер
    func setupSaveButtonAction() {
        addressView.onSaveButtonTapped = { [weak self] newAddress in
            guard let self else { return }
            viewModel.saveNewAddressButtonTapped(newAddress)
        }
    }
}

// MARK: - Data binding
private extension AddNewAddressViewController {
    func dataBinding() {
        viewModel.mainAddressPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mainAddress in
                guard let self else { return }
                showMainAddressOnMap(mainAddress)
                updateUIWithData(mainAddress)
            }
            .store(in: &cancellables)
    }
}

// MARK: - AddNewAddressViewProtocol
extension AddNewAddressViewController: AddNewAddressViewProtocol {
    // Метод находит координаты по адресу и центрирует карту по ним
    func showMainAddressOnMap(_ mainAddress: Address?) {
        guard let mainAddress else { print("No main address"); return }
        mapView.showAddressOnMap(mainAddress)
    }

    func updateUIWithData(_ mainAddress: Address?) {
        guard let mainAddress else { print("No main address"); return }
        addressView.updateUIWithAddress(mainAddress)
    }
}

// MARK: - Hide keyboard by tap
private extension AddNewAddressViewController {
    func setupGestureToDissmissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
