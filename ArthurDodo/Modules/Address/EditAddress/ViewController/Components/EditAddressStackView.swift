import UIKit
import AppUIComponentsSPM

final class EditAddressStackView: UIStackView {

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
    private lazy var saveAddressButton = AppButtons(type: .cartOrange, text: "Сохранить")
    private lazy var deleteAddressButton = AppButtons(type: .cartGray, text: "Удалить")

    private lazy var buttonsStackView = AppStackView([deleteAddressButton, saveAddressButton], axis: .horizontal, spacing: 10, distribution: .fillEqually)

    var onSaveNewAddress: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Обновляем UI в соответствии с полученными данными (заполняем адрес)
    func updateUIWithData(_ addressToEdit: Address) {
        editStreetAndFlatAddressView.configureView(addressToEdit.cityStreetHouse)
        editNameOfAddressView.configureView(addressToEdit.name)
        editEntranceOfAddressView.configureView(addressToEdit.entrance?.description)
        editCodeOfAddressView.configureView(addressToEdit.entranceCode)
        editFloorOfAddressView.configureView(addressToEdit.floor?.description)
        editFlatOfAddressView.configureView(addressToEdit.apartment?.description)
        editCommentToAddressView.configureView(addressToEdit.comments)
    }

    // Обновляем только улицу и дом
    func updateUIShortAddress(_ newShortAddress: String) {
        editStreetAndFlatAddressView.configureView(newShortAddress)
    }
}

// MARK: - Setup UI
private extension EditAddressStackView {
    func setupUI() {
        [editStreetAndFlatAddressView, editNameOfAddressView, entranceAndCodeStackView, floorAndFlatStackView, editCommentToAddressView, buttonsStackView].forEach { addArrangedSubview($0) }
        axis = .vertical
        distribution = .equalSpacing
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}

// MARK: - Setup Actions
extension EditAddressStackView {
    func setupActions() {
        setupButtonAction()
    }

    func setupButtonAction() {
        saveAddressButton.onButtonTapped = { [weak self] in
            guard let self else { print("Error: self is nil"); return }
            onSaveNewAddress?()
        }
    }
}
