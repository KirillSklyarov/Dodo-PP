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

    // MARK: - Init
    init(addressToEdit: Address) {
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
        setupActions()
    }

    func updateUIWithData() {
        print(self.addressToEdit)
        addressContainerView.updateUIWithAddress(addressToEdit)
    }
}

// MARK: - Setup Actions
private extension EditAddressViewController {
    func setupActions() {
        setupButtonAction()
    }

    func setupButtonAction() {
        addressContainerView.setupButtonAction(addressToEdit)
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
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
