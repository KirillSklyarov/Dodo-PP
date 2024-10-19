//
//  AddressViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import UIKit
import MapKit
import CoreLocation

final class AddressViewController: UIViewController {

    // MARK: - Properties
    private let rightPadding: CGFloat = -20
    private let bottomPadding: CGFloat = -20

    private lazy var contentStackView = AddressHeaderView()

    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
    private lazy var userTrackingButton = MKUserTrackingButton(mapView: mapView)

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupMapView()
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
        view.addSubviews(mapView, contentStackView, userTrackingButton)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            userTrackingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding),
            userTrackingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding)
        ])
    }
}

// MARK: - Setup Map&Location
extension AddressViewController: CLLocationManagerDelegate {
    func setupMapView() {
        mapView.backgroundColor = .darkGray
        mapView.showsUserLocation = true
        configureLocationManager()
    }

    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Получено местоположение: \(location.coordinate)")

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        print("Обновление местоположения остановлено.")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("We cannot get your location: \(error.localizedDescription)")
    }
}
