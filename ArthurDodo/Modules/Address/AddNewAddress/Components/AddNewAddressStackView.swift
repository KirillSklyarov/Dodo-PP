import UIKit

final class AddNewAddressStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var editStreetAndFlatAddressView = EditAddressTextFieldView(.streetAndFlat)
    private lazy var editNameOfAddressView = EditAddressTextFieldView(.nameOfAddress)
    private lazy var editEntranceOfAddressView = EditAddressTextFieldView(.entrance)
    private lazy var editCodeOfAddressView = EditAddressTextFieldView(.codeOfEntrance)
    private lazy var entranceAndCodeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editEntranceOfAddressView, editCodeOfAddressView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    private lazy var editFloorOfAddressView = EditAddressTextFieldView(.floor)
    private lazy var editFlatOfAddressView = EditAddressTextFieldView(.flat)
    private lazy var floorAndFlatStackView = AppStackView([editFloorOfAddressView, editFlatOfAddressView], axis: .horizontal, spacing: 10, distribution: .fillEqually)
    private lazy var editCommentToAddressView = EditAddressTextFieldView(.comment)
    private lazy var saveAddressButton = CartButton(title: "Сохранить", isCart: false)

    private var newShortAddress: String?

    var onSaveButtonTapped: ((String) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension AddNewAddressStackView {
    // Обновляем только улицу и дом
    func updateUIShortAddress(_ newShortAddress: String) {
        editStreetAndFlatAddressView.configureView(newShortAddress)
        self.newShortAddress = newShortAddress
    }
}

// MARK: - Setup UI
private extension AddNewAddressStackView {
    func setupUI() {
        [editStreetAndFlatAddressView, editNameOfAddressView, entranceAndCodeStackView, floorAndFlatStackView, editCommentToAddressView, saveAddressButton].forEach { addArrangedSubview($0) }
        axis = .vertical
        distribution = .equalSpacing
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}

// MARK: - Setup Actions
extension AddNewAddressStackView {
    func setupAction() {
        setupButtonAction()
    }

    // В качестве примера отправляем новый адрес на сервер
    func setupButtonAction() {
        saveAddressButton.onButtonTapped = { [weak self] in
            guard let self,
                  let newShortAddress else { print("Error: self is nil"); return }
            print(#function)
            onSaveButtonTapped?(newShortAddress)
        }
    }
}
