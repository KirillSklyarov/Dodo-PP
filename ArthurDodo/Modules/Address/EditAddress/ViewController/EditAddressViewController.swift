import UIKit
import AppUIComponentsSPM

protocol EditAddressViewControllerInput: BaseViewControllerInput where inputData == Address {
    func updateShortAddress(_ address: Address)
}

final class EditAddressViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var mapView = EditAddressMapView()
    private lazy var addressContainerView = EditAddressView()
    private lazy var contentStackView = AppStackView([mapView, addressContainerView], axis: .vertical, spacing: -5, distribution: .fillEqually)
    private lazy var dismissButton = AppDismissButtonView(type: .chevron)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Output
    let output: any EditAddressViewControllerOutput

    // MARK: - Init
    init(output: any EditAddressViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("EditAddressViewController deinit")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - EditAddressViewControllerInput
extension EditAddressViewController: EditAddressViewControllerInput {
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
        updateAddress(data)
        isShowContent(true)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }

    func updateShortAddress(_ address: Address) {
        let shortAddress = address.cityStreetHouse
        addressContainerView.updateShortAddress(shortAddress)
    }
}

// MARK: - Setup UI
private extension EditAddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView, dismissButton, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        dismissButton.setLocalConstraints(isSafeArea: true, top: 0, left: 20)
        contentStackView.setLocalConstraints(isSafeArea: true, bottom: 0, left: 0, right: 0)
        contentStackView.setLocalConstraints(isSafeArea: false, top: 0)

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
            output.sendAction(.saveButtonTapped)
        }
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] shortAddress in
            self?.output.sendAction(.mapIsMoving(shortAddress))
        }
    }

    // Настраиваем кнопку Закрыть
    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.output.sendAction(.dismissButtonTapped)
        }
    }
}

// MARK: - Supporting methods
private extension EditAddressViewController {
    func isShowContent(_ show: Bool) {
        let content = [dismissButton, contentStackView]
        content.forEach { $0.alpha = show ? 1 : 0 }
    }

    // Обновляет адрес на вью
    func updateAddress(_ addressToEdit: Address?) {
        guard let addressToEdit else { print("We have no address"); return }
        updateAddressDetailsView(addressToEdit)
        showAddressOnMap(addressToEdit)
        updateShortAddress(addressToEdit)
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
