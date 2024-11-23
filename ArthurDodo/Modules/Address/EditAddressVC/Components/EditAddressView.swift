import UIKit

final class EditAddressView: UIView {

    // MARK: - Properties
    private lazy var addressStackView = EditAddressStackView()

    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    var onSaveAddressTapped: (() -> Void)?

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
extension EditAddressView {
    func updateUIWithAddress(_ addressToEdit: Address) {
        addressStackView.updateUIWithData(addressToEdit)
    }

    func updateShortAddress(_ basicAddress: String) {
        addressStackView.updateUIShortAddress(basicAddress)
    }
}

// MARK: - Setup actions
private extension EditAddressView {
    func setupAction() {
        addressStackView.onSaveNewAddress = { [weak self] in
            self?.onSaveAddressTapped?()
        }
    }
}

// MARK: - Setup UI
private extension EditAddressView {
    func setupUI() {
        backgroundColor = AppColors.backgroundBlack
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
