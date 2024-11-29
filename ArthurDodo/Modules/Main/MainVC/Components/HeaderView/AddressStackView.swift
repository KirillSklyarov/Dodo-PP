import UIKit

// Вью с адресом и временем доставки на главном экране
final class AddressStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var courierView = CourierView()
    private lazy var addressLabel = AppLabelDS(type: .addressName, text: "Укажите адрес доставки")
    private lazy var deliveryTimeLabel = AppLabelDS(type: .addressTime, text: "около 40 минут")
    private lazy var chevronImageView = AppImageViewDS(type: .chevronDown)

    private lazy var contentStackView = setupContentStackView()

    var onAddressTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        courierView.layer.cornerRadius = frame.height / 2
    }
}

// MARK: - Public methods
extension AddressStackView {
    func updateAddress(_ address: String) {
        addressLabel.text = address
//        isUIVisible(true)
    }

}

// MARK: - Setup UI
private extension AddressStackView {
    func setup() {
        [courierView, contentStackView].forEach { addArrangedSubview($0) }
        axis = .horizontal
        distribution = .fill
        spacing = 20

        setupTapGesture()

        courierView.widthAnchor.constraint(equalTo: courierView.heightAnchor).isActive = true
    }

    func setupContentStackView() -> UIStackView {
        let addressNameStackView = AppStackView([addressLabel, chevronImageView], axis: .horizontal, spacing: 5)
        let labelStackView = AppStackView([addressNameStackView, deliveryTimeLabel], axis: .vertical, spacing: 0, alignment: .leading)
        return labelStackView
    }
}

// MARK: - Setup Tap gesture
private extension AddressStackView {
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc func addressTapped() {
        onAddressTapped?()
    }
}
