//
//  EditAddressStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 19.10.2024.
//

import UIKit

final class EditAddressStackView: UIStackView {

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
    private lazy var floorAndFlatStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editFloorOfAddressView, editFlatOfAddressView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    private lazy var editCommentToAddressView = EditAddressTextFieldView(.comment)
    private lazy var saveAddressButton = CartButton(title: "Сохранить", isCart: false)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
    func updateUIBasicAddress(_ newBasicAddress: String) {
        editStreetAndFlatAddressView.configureView(newBasicAddress)
    }
}

// MARK: - Setup UI
private extension EditAddressStackView {
    func setupUI() {
        [editStreetAndFlatAddressView, editNameOfAddressView, entranceAndCodeStackView, floorAndFlatStackView, editCommentToAddressView, saveAddressButton].forEach { addArrangedSubview($0) }
        axis = .vertical
        distribution = .equalSpacing
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}

// MARK: - Setup Actions
extension EditAddressStackView {
    func setupButtonAction(_ addressToEdit: Address) {
        saveAddressButton.onButtonTapped = { [weak self] in
            guard self != nil else { return }
            NetworkManager.shared.updateUserAddress(addressToEdit) { result in
                switch result {
                case .success(let address):
                    print("Данные успешно обновлены: \(address)")
                case .failure(let error):
                    print("Данные НЕ обновлены: \(error)")
                }
            }
        }
    }
}
