import UIKit

final class AddNewAddressStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var editStreetAndFlatAddressView = AddressTextFieldView(.streetAndFlat)
    private lazy var editNameOfAddressView = AddressTextFieldView(.nameOfAddress)
    private lazy var editEntranceOfAddressView = AddressTextFieldView(.entrance)
    private lazy var editCodeOfAddressView = AddressTextFieldView(.codeOfEntrance)
    private lazy var entranceAndCodeStackView = AppStackView([editEntranceOfAddressView, editCodeOfAddressView], axis: .horizontal, spacing: 10, distribution: .fillEqually)
    private lazy var editFloorOfAddressView = AddressTextFieldView(.floor)
    private lazy var editFlatOfAddressView = AddressTextFieldView(.flat)
    private lazy var floorAndFlatStackView = AppStackView([editFloorOfAddressView, editFlatOfAddressView], axis: .horizontal, spacing: 10, distribution: .fillEqually)
    private lazy var editCommentToAddressView = AddressTextFieldView(.comment)
    private lazy var saveAddressButton = CartButton(title: "Доставить сюда", isCart: false)

    private var newShortAddress: String?

    var onSaveButtonTapped: ((String) -> Void)?
    var onTextFieldEndEditing: ((String) -> Void)?

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
        spacing = 10
    }
}

// MARK: - Setup Actions
extension AddNewAddressStackView {
    func setupAction() {
        setupButtonAction()
        setupTextFieldAction() 
    }

    // В качестве примера отправляем новый адрес на сервер
    func setupButtonAction() {
        saveAddressButton.onButtonTapped = { [weak self] in
            guard let self,
                  let newShortAddress else { print("Error: self is nil"); return }
            onSaveButtonTapped?(newShortAddress)
        }
    }

    func setupTextFieldAction() {
//        editStreetAndFlatAddressView.onTextFieldBegin = { [weak self] text in
//            self?.onTextFieldBegin?(text)
//        }

        editNameOfAddressView.onTextFieldEndEditing = { [weak self] text in
            self?.onTextFieldEndEditing?(text)
        }

        editCodeOfAddressView.onTextFieldBeginEditing = { [weak self] in
            self?.onTextFieldBeginEditing?()
        }
    }
}
