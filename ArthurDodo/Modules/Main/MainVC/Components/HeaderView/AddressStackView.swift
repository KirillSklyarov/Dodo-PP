import UIKit

final class AddressStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var courierView = CourierView()
    private lazy var addressLabel = AppLabelDS(type: .addressName, text: "Укажите адрес доставки")
    private lazy var deliveryTimeLabel = AppLabelDS(type: .addressTime, text: "около 40 минут")
    private lazy var chevronImageView = AppImageView(viewImage: .main(.chevronDown), tintColor: .white)
    private lazy var addressNameStackView = AppStackView([addressLabel, chevronImageView], axis: .horizontal, spacing: 5)
    private lazy var labelStackView = AppStackView([addressNameStackView, deliveryTimeLabel], axis: .vertical, spacing: 0, alignment: .leading)

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
        [courierView, labelStackView].forEach { addArrangedSubview($0) }
        axis = .horizontal
        distribution = .fill
        spacing = 20

        setupTapGesture()

        courierView.widthAnchor.constraint(equalTo: courierView.heightAnchor).isActive = true
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc func addressTapped() {
        onAddressTapped?()
    }
}
