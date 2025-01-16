import UIKit
import ActivityIndicatorSPM

protocol AddNewAddressViewControllerInput: BaseViewControllerInput where inputData == Address {

}

// ВАЖНО: мы вызываем метод initialize у viewModel только после загрузки карты (это замыкание  mapView.onMapLoaded), тогда не прилетают ошибки при загрузке адреса
final class AddNewAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .chevron)
    private lazy var mapView = AddAddressMapView()
    private lazy var addressView = AddAddressView()
    private lazy var contentStackView = AppStackView([mapView, addressView], axis: .vertical, spacing: -5, distribution: .fill)

    private lazy var activityIndicator = ActivityIndicatorSPM.AppActivityIndicator()

    // MARK: - Output
    let output: any AddNewAddressViewControllerOutput

    // MARK: - Init
    init(output: any AddNewAddressViewControllerOutput) {
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

        setupGestureToDissmissKeyboard()
    }
}

// MARK: - AddNewAddressViewControllerInput
extension AddNewAddressViewController: AddNewAddressViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        isShowContent(false)
    }

    func configure(with data: Address) {
        activityIndicator.stopAnimating()
        updateUI(data)
        isShowContent(true)
    }

    func showError() {
        isShowContent(false)
        activityIndicator.stopAnimating()
    }
}

// MARK: - Setup UI
private extension AddNewAddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStackView, dismissButton, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        dismissButton.setLocalConstraints(isSafeArea: true, top: 0, left: 20)
        contentStackView.setLocalConstraints(top: 0, left: 0, right: 0)
        contentStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10).withPriority(.defaultLow).isActive = true // Позволяет убирать конфликты с клавиатурой

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
            self?.output.sendAction(.dismissButtonTapped)
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
            output.sendAction(.saveNewAddressButtonTapped(newAddress))
        }
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

// MARK: - Supporting methods
private extension AddNewAddressViewController {
    func isShowContent(_ show: Bool) {
        let uiComponents = [dismissButton, contentStackView]
        uiComponents.forEach { $0.alpha = show ? 1 : 0 }
    }

    func updateUI(_ address: Address) {
        showMainAddressOnMap(address)
        updateUIWithData(address)
    }

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
