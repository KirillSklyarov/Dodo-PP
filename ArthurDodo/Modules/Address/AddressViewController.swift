//
//  AddressViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import UIKit

final class AddressViewController: UIViewController {

    // MARK: - Properties
    private lazy var addressHeaderStackView = AddressHeaderView()
    private lazy var mapView = MapView(isPinHidden: true, isTrackingButtonHidden: true)
    private lazy var addressView = DeliveryAddressView()
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapView, addressView])
        stackView.axis = .vertical
        stackView.spacing = -10
        return stackView
    }()

    private let storage = DataStorage.shared
    private lazy var router = Router(baseVC: self)

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
        setupActions()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        showDeliveryAddressVC()
//    }
}

// MARK: - Fetch data from Network
extension AddressViewController {
    func fetchData() {
        storage.fetchUserAddresses()
        storage.onDataFetchedSuccessfully = { [weak self] in
            self?.addressView.updateUI()
        }
    }
}

// MARK: - Setup UI
private extension AddressViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStack, addressHeaderStackView)
        setupConstraints()
        setupMapView()
    }

    func setupMapView() {
        mapView.isUserInteractionEnabled = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Setup Actions
private extension AddressViewController {
    func setupActions() {
        setupAddressHeaderAction()
        setupAddressViewAction()
    }

    func setupAddressHeaderAction() {
        addressHeaderStackView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

//        addressHeaderStackView.onDeliveryButtonTapped = { [weak self] in
//            self?.showDeliveryAddressVC()
//        }
    }

    func setupAddressViewAction() {
        addressView.onEditAddressCellTapped = { [weak self] address in
            self?.showEditAddressVC(address)
        }
    }

    func showEditAddressVC(_ address: Address) {
        router.navigate(to: .editAddress) { [weak self] editAddressVC in
            guard let editAddressVC = editAddressVC as? EditAddressViewController else { print("We can't cast to EditAddressViewController"); return }
            editAddressVC.addressToEdit = address
        }
    }
}
