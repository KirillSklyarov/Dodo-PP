//
//  EditAddressViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 13.10.2024.
//

import UIKit

enum AddressTextFieldType: String {
    case streetAndFlat = "Город, улица и дом"
    case nameOfAddress = "Название места"
    case entrance = "Подъезд"
    case codeOfEntrance = "Код на двери"
    case floor = "Этаж"
    case flat = "Квартира"
    case comment = "Комментарий к адресу"
}

final class EditAddressViewController: UIViewController {

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 30
    private let bottomPadding: CGFloat = -10
    private let buttonWight: CGFloat = 150

    var addressToEdit: AddressModel

    // MARK: - UI Properties
    private lazy var editStreetAndFlatAddressView = AddressTextFieldView(.streetAndFlat)
    private lazy var editNameOfAddressView = AddressTextFieldView(.nameOfAddress)
    private lazy var editEntranceOfAddressView = AddressTextFieldView(.entrance)
    private lazy var editCodeOfAddressView = AddressTextFieldView(.codeOfEntrance)
    private lazy var entranceAndCodeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editEntranceOfAddressView, editCodeOfAddressView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    private lazy var editFloorOfAddressView = AddressTextFieldView(.floor)
    private lazy var editFlatOfAddressView = AddressTextFieldView(.flat)
    private lazy var floorAndFlatStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editFloorOfAddressView, editFlatOfAddressView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    private lazy var editCommentToAddressView = AddressTextFieldView(.comment)
    private lazy var saveAddressButton = CartButton(isHidden: false, title: "Сохранить")
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editStreetAndFlatAddressView, editNameOfAddressView, entranceAndCodeStackView, floorAndFlatStackView, editCommentToAddressView, saveAddressButton])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Init
    init(addressToEdit: AddressModel) {
        self.addressToEdit = addressToEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIWithData()
    }

    func updateUIWithData() {
        print(self.addressToEdit)
        editStreetAndFlatAddressView.configureView(addressToEdit.cityStreetHouse)
        editNameOfAddressView.configureView(addressToEdit.name)
        editEntranceOfAddressView.configureView(addressToEdit.entrance?.description ?? "")
        editCodeOfAddressView.configureView(addressToEdit.entranceCode ?? "")
        editFloorOfAddressView.configureView(addressToEdit.floor?.description ?? "")
        editFlatOfAddressView.configureView(addressToEdit.apartment?.description ?? "")
        editCommentToAddressView.configureView(addressToEdit.comments ?? "")
    }
}

// MARK: - Setup UI
private extension EditAddressViewController {
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
