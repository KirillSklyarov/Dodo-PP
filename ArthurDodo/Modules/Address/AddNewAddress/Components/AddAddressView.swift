import UIKit

final class AddAddressView: UIView {

    // MARK: - Properties
    private lazy var addressStackView = AddNewAddressStackView()

    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    var onSaveButtonTapped: ((String) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension AddAddressView {
    func updateUIWithAddress(_ addressToShow: Address) {
        let shortAddress = addressToShow.cityStreetHouse
        addressStackView.updateUIShortAddress(shortAddress)
    }

    func setupSaveButtonAction(_ addressToEdit: Address) {
        addressStackView.setupButtonAction()
    }

    func updateShortAddress(_ shortAddress: String) {
        addressStackView.updateUIShortAddress(shortAddress)
    }
}

// MARK: - Setup actions
private extension AddAddressView {
    func setupAction() {
        addressStackView.onSaveButtonTapped = { [weak self] newShortAddress in
            self?.onSaveButtonTapped?(newShortAddress)
        }
    }
}

// MARK: - Setup UI
private extension AddAddressView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubviews(addressStackView)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            addressStackView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            addressStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            addressStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            addressStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

