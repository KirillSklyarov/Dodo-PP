import UIKit

final class DeliveryAddressView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(text: "Мои адреса", textColor: .white, font: .bold(size: 26))

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
        button.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var headerStackView = AppStackView([titleLabel, addAddressButton], axis: .horizontal)

    private lazy var deliveryButton = CartButton(title: "Доставить сюда", isCart: false)
    private lazy var addressTableView = AddressListTableView()
    private lazy var contentStackView = AppStackView([headerStackView, addressTableView, deliveryButton], axis: .vertical, spacing: 10)

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 20
    private let bottomPadding: CGFloat = -10
    private let buttonWidth: CGFloat = 150

    var onEditAddressCellTapped: ((Address) -> Void)?
    var onAddNewAddressButtonTapped: (() -> Void)?
    var onAddressCellTapped: ((Address) -> Void)?
    var onDeliveryButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        addressTableView.reloadData()
    }

    func getAddresses(_ addresses: [Address]) {
        addressTableView.getAddresses(addresses)
    }
}

// MARK: - Setup UI
private extension DeliveryAddressView {
    func setupUI() {
        backgroundColor = AppColors.backgroundBlack
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomPadding)
        ])
    }
}

// MARK: - Setup Actions
private extension DeliveryAddressView {
    func setupActions() {
        setupAddressTableViewActions()
        setupDeliveryButtonAction()
    }

    func setupAddressTableViewActions() {
        addressTableView.onEditAddressButtonTapped = { [weak self] address in
            guard let self else { return }
            onEditAddressCellTapped?(address)
        }

        addressTableView.onCellTapped = { [weak self] address in
            self?.onAddressCellTapped?(address)
        }
    }

    func setupDeliveryButtonAction() {
        deliveryButton.onButtonTapped = { [weak self] in
            self?.onDeliveryButtonTapped?()
        }
    }

    @objc func addAddressButtonTapped() {
        onAddNewAddressButtonTapped?()
    }
}
