//
//  AddressViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import UIKit

final class AddressViewController: UIViewController {

    // MARK: - Properties
    private lazy var contentStackView = AddressHeaderView()
    private lazy var mapView = MapView()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
}

// MARK: - Setup Actions
private extension AddressViewController {
    func setupActions() {
        contentStackView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        contentStackView.onDeliveryButtonTapped = { [weak self] in
            self?.showDeliveryAddressVC()
        }
    }

    func showDeliveryAddressVC() {
        let vc = DeliveryAddressSheetView()
        guard let configureSheet = vc.sheetPresentationController else { return }
        configureSheet.detents = [.medium()]
        configureSheet.prefersGrabberVisible = true
        present(vc, animated: true)
    }
}

// MARK: - Setup UI
private extension AddressViewController {
    func setupUI() {
        view.addSubviews(mapView, contentStackView)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
