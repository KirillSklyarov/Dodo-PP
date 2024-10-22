//
//  EditAddressViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 13.10.2024.
//

import UIKit

final class EditAddressViewController: UIViewController {

    // MARK: - Properties
    var addressToEdit: Address
    private let leftInset: CGFloat = 20

    // MARK: - UI Properties
    private lazy var mapView = MapView()
    private lazy var addressContainerView = EditAddressView()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapView, addressContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -5
        return stackView
    }()
    private lazy var dismissButton = DismissButtonView(isChevron: true)

    // MARK: - Init
    init(addressToEdit: Address) {
        self.addressToEdit = addressToEdit
        super.init(nibName: nil, bundle: nil)
        getCoord()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getCoord() {
        let shortAddress = addressToEdit.cityStreetHouse
        mapView.getCoordinates(from: shortAddress)
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIWithData()
        setupActions()
    }

    func updateUIWithData() {
        print(self.addressToEdit)
        addressContainerView.updateUIWithAddress(addressToEdit)
    }
}

// MARK: - Setup UI
private extension EditAddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStackView, dismissButton)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
        ])
    }
}

// MARK: - Setup Actions
private extension EditAddressViewController {
    func setupActions() {
        setupDismissButtonAction()
        setupSaveButtonAction()
        setupMapViewAction()
    }

    // Настраиваем кнопку Сохранить
    func setupSaveButtonAction() {
        addressContainerView.setupSaveButtonAction(addressToEdit)
    }

    // Настраиваем когда двигается карта, то двигается и адрес в таблице
    func setupMapViewAction() {
        mapView.onChangeAddress = { [weak self] address in
            self?.addressContainerView.updateBasicAddress(address)
        }
    }

    // Настраиваем кнопку Закрыть
    func setupDismissButtonAction() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
