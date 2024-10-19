//
//  EditAddressViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 13.10.2024.
//

import UIKit

final class EditAddressViewController: UIViewController {

    // MARK: - Properties
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = -0
    private let topPadding: CGFloat = 0
    private let bottomPadding: CGFloat = -10
    private let buttonWight: CGFloat = 150

    var addressToEdit: Address

    // MARK: - UI Properties
    private lazy var mapView = MapView()
    private lazy var addressStackView = EditAddressStackView()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapView, addressStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -5
        addressStackView.backgroundColor = AppColors.backgroundBlack
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
        addressStackView.updateUIWithData(addressToEdit)
    }
}

// MARK: - Setup Actions
private extension EditAddressViewController {
    func setupActions() {
        setupButtonAction()
    }

    func setupButtonAction() {
        addressStackView.setupButtonAction(addressToEdit)
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
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding)
        ])
    }
}
