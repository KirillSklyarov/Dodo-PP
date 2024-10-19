//
//  MapView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 19.10.2024.
//

import UIKit
import MapKit
import CoreLocation

final class MapView: UIView {

    private let rightPadding: CGFloat = -20
    private let bottomPadding: CGFloat = -20

    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
    private lazy var userTrackingButton = MKUserTrackingButton(mapView: mapView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupMapView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension MapView {
    func setupUI() {
        addSubviews(mapView, userTrackingButton)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            userTrackingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding),
            userTrackingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding)
        ])
    }
}

// MARK: - Setup Map
private extension MapView {
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
}

// MARK: - CLLocationManagerDelegate
extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Получено местоположение: \(location.coordinate)")

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        print("Обновление местоположения остановлено.")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Невозможно получить месторасположение: \(error.localizedDescription)")
    }
}

