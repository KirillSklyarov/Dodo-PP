import UIKit

final class AddNewAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var mapView = AddAddressMapView()
    private lazy var addressView = AddAddressView()
    private lazy var contentStackView = AppStackView([mapView, addressView], axis: .vertical, spacing: -5, distribution: .fill)
    private lazy var dismissButton = AppDismissButtonView(type: .chevron)

    // MARK: - Properties
    private var mainAddress: Address?
    private let storage: DataStorage

    var onDismissButtonTapped: (() -> Void)?
    var onSaveNewAddressButtonTapped: (() -> Void)?

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
        setupActions()
        fetchData()

        setupGestureToDissmissKeyboard()
    }
}

// MARK: - Fetch Data
private extension AddNewAddressViewController {
    // Запрашиваем основной адрес у хранилища и показываем его на карте
    func fetchData() {
        mainAddress = storage.getMainAddress()
        showMainAddressOnMap() // Показываем основной адрес на карте
        updateUIWithData() // Обновляем таблицу с данными адреса (город, дом и проч.)
    }
}

// MARK: - Public methods
extension AddNewAddressViewController {
    func updateUIWithData() {
        guard let mainAddress else { print("We have no address to edit"); return }
        addressView.updateUIWithAddress(mainAddress)
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
            self?.onDismissButtonTapped?()
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
            passNewAddressToStorage(newAddress)
            onSaveNewAddressButtonTapped?()
        }
    }
}

// MARK: - Supporting methods
private extension AddNewAddressViewController {
    // Метод находит координаты по адресу и центрирует карту по ним
    func showMainAddressOnMap() {
        guard let mainAddress else { print("We have no main address"); return }
        mapView.showAddressOnMap(mainAddress)
    }

    // Отправляем новый адрес в хранилище
    func passNewAddressToStorage(_ newAddress: Address) {
        storage.addAddress(newAddress)
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
