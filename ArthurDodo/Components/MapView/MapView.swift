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

    // MARK: - Properties
    private let rightInset: CGFloat = -20
    private let bottomInset: CGFloat = -20
    private let pinImageSize: CGFloat = 50

    private var isAnimating = false
    private let geocoder = CLGeocoder()
    private var addressCoordinates: CLLocationCoordinate2D?

    var onChangeAddress: ((String) -> Void)?

    // MARK: - UI Properties
    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.backgroundColor = AppColors.backgroundBlack
        button.tintColor = .white
        return button
    }()
    private lazy var pinView: UIImageView = {
        let image = UIImage(systemName: "mappin")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: pinImageSize).isActive = true
        view.widthAnchor.constraint(equalToConstant: pinImageSize).isActive = true
        return view
    }()

    // MARK: - Init
    init(frame: CGRect = .zero, isPinHidden: Bool = false, isTrackingButtonHidden: Bool = false) {
        super.init(frame: frame)
        setupUI()
        setupMapView()
        pinView.isHidden = isPinHidden
        userTrackingButton.isHidden = isTrackingButtonHidden
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension MapView {
    func setupUI() {
        addSubviews(mapView, userTrackingButton, pinView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            userTrackingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: bottomInset),
            userTrackingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),

            pinView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor)
        ])
    }
}

// MARK: - Setup Map
private extension MapView {
    func setupMapView() {
        mapView.delegate = self
        configureLocationManager()
//        testGetAddress(addressCoordinates)
    }

    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - Setup Animation
private extension MapView {
    func showPinAnimation() {
        DispatchQueue.main.async {
            self.animatePin()
        }
    }

    func animatePin() {
        if !isAnimating { showAnimation() }
    }

    func showAnimation() {
        isAnimating = true
        let pinAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        pinAnimation.values = [0, -20, 0]
        pinAnimation.keyTimes = [0, 0.5, 1]
        pinAnimation.duration = 1.0
        pinView.layer.add(pinAnimation, forKey: "bounce")
        DispatchQueue.main.asyncAfter(deadline: .now() + pinAnimation.duration) {
            self.isAnimating = false
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Получено местоположение: \(location.coordinate)")
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        showPinAnimation()

        locationManager.stopUpdatingLocation()
        print("Обновление местоположения остановлено.")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Невозможно получить месторасположение: \(error.localizedDescription)")
    }
}

// MARK: - MKMapViewDelegate
extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapCenter = mapView.centerCoordinate
        showPinAnimation()
        print("New coordinates: \(mapCenter.latitude), \(mapCenter.longitude)")
        getAddress(mapCenter)
    }
}

// MARK: - Get Address from coordinates
 extension MapView {
    func getAddress(_ coordinates: CLLocationCoordinate2D) {
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { placemarks, error in
            if let error = error {
                print("Error: \(error.localizedDescription)"); return }

            guard let placemark = placemarks?.first else {
                print("No placemark found"); return }

            let city = placemark.locality ?? ""
            let street = placemark.thoroughfare ?? ""
            let apart = placemark.subThoroughfare ?? ""

            let newAddress = "\(city), \(street), \(apart)"
            self.onChangeAddress?(newAddress)
        }
    }

     func testGetAddress(_ coordinates: CLLocationCoordinate2D) {
         geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { placemarks, error in
             if let error = error {
                 print("Error: \(error.localizedDescription)"); return }

             guard let placemark = placemarks?.first else {
                 print("No placemark found"); return }

             let city = placemark.locality ?? ""
             let street = placemark.thoroughfare ?? ""
             let apart = placemark.subThoroughfare ?? ""

             let newAddress = "\(city), \(street), \(apart)"
             print("newAddress \(newAddress)")
         }
     }

     func getCoordinates(from address: String) {
         geocoder.geocodeAddressString(address) { placemarks, error in
             if let error = error {
                 print("Error: \(error.localizedDescription)"); return }
             guard let placemark = placemarks?.first else {
                 print("No placemark found"); return }
             if let coordinates = placemark.location?.coordinate {
                 print("coordinates: \(coordinates)")

                 self.addressCoordinates = coordinates
                 self.setMapViewCenter(coordinates)
             }
         }
     }

     func setMapViewCenter(_ coordinates: CLLocationCoordinate2D) {
         if let addressCoordinates {
             let region = MKCoordinateRegion(center: addressCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
             mapView.setRegion(region, animated: true)
         }
     }
}
