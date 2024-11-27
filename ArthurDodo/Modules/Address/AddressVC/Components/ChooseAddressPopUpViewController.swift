import UIKit

final class AddressPopUpViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(textColor: .white, font: .bold(size: 26))

    private lazy var addAddressButton: UIButton = {
        let button = UIButton()
        let title = "+ Новый адрес"
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle = AttributedString(title, attributes:
                                                    AttributeContainer([ .font: AppFonts.bold14]))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = AppColors.buttonGray
        config.cornerStyle = .capsule
        button.configuration = config
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }()
    private lazy var headerStackView = AppStackView([titleLabel, addAddressButton], axis: .horizontal)

    private lazy var deliveryButton = CartButton(title: "Доставить сюда", isCart: false)
    private lazy var addressTableView = AddressListTableView()

    private lazy var contentStackView = AppStackView([headerStackView, addressTableView, deliveryButton], axis: .vertical, spacing: 10)

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 30
    private let bottomPadding: CGFloat = -10
    private let buttonWidth: CGFloat = 150

    private let storage: DataStorage

    var onShowEditAddressVC: ((Address) -> Void)?

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
        fetchData()
        setupUI()
        setupActions()
    }
}

// MARK: - Fetch data from Network
extension AddressPopUpViewController {
    func fetchData() {
        storage.fetchUserAddresses()
        storage.onDataFetchedSuccessfully = { [weak self] in
            self?.addressTableView.reloadData()
        }
    }
}

// MARK: - Setup Actions
private extension AddressPopUpViewController {
    func setupActions() {
        setupAddressTableViewActions()
        setupDeliveryButtonAction()
    }

    func setupAddressTableViewActions() {
        addressTableView.onEditAddressButtonTapped = { [weak self] address in
            guard let self else { return }
            showEditAddressVC(address)
        }
    }

    func showEditAddressVC(_ address: Address) {
        onShowEditAddressVC?(address)
    }

    func setupDeliveryButtonAction() {
        deliveryButton.onButtonTapped = {
            print("We're here")
        }
    }
}

// MARK: - Setup UI
private extension AddressPopUpViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding)
        ])
    }
}
