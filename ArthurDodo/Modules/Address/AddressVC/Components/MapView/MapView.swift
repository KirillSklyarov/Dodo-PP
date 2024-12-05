import UIKit
import MapKit
import CoreLocation

final class MapView: UIView {

    // MARK: - UI Properties
    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
    private lazy var userTrackingButton = UserTrackingButton(mapView: mapView)
    private lazy var pinView = AppImageView(type: .mapPin)

    // MARK: - Properties
    private let locationRadius: CLLocationDistance = 500

    private var isAnimating = false
    private let geocoder = CLGeocoder()
    private var addressCoordinates: CLLocationCoordinate2D?

    private var address: String?

    var onChangeAddress: ((String) -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, isHidden: Bool = true, isPinHidden: Bool = false, isTrackingButtonHidden: Bool = false, address: String? = nil) {
        super.init(frame: frame)
        setupUI()
        setupMapView()
        pinView.isHidden = isPinHidden
        userTrackingButton.isHidden = isTrackingButtonHidden
        hideEmptyMap(isHidden)
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
        mapView.setConstraints()
        userTrackingButton.setLocalConstraints(isSafeArea: true, bottom: 20, right: 20)

        NSLayoutConstraint.activate([
            pinView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor)
        ])
    }
}

// MARK: - Setup Map
private extension MapView {
    func setupMapView() {
//        mapView.delegate = self
//        configureLocationManager()
    }

    func configureLocationManager() {
//        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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

    // Настраиваем анимацию булавки
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
//extension MapView: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        print("Получено местоположение: \(location.coordinate)")
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//        mapView.setRegion(region, animated: true)
//        showPinAnimation()
//
//        locationManager.stopUpdatingLocation()
//        print("Обновление местоположения остановлено.")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
//        print("Невозможно получить месторасположение: \(error.localizedDescription)")
//    }
//}

// MARK: - MKMapViewDelegate
//extension MapView: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let mapCenter = mapView.centerCoordinate
//        showPinAnimation()
//        print("New coordinates: \(mapCenter.latitude), \(mapCenter.longitude)")
//        getAddress(mapCenter)
//    }
//}

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
}

extension MapView {
    // Показываем точку на карте по адресу
    func showAddressOnMap(_ address: Address) {
        let shortAddress = address.cityStreetHouse

        getCoordinates2(from: shortAddress) { [weak self] coordinates, error in // Получаем координаты
            guard let self, let coordinates else { return }
            showMap() // Показываем карту
            setMapViewCenter(coordinates, radius: locationRadius) // Показываем карту по координатам
        }
    }


    // Получаем координаты из адреса
    private func getCoordinates2(from address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first,
                  let coordinates = placemark.location?.coordinate else {
                print("No placemark found"); return }

            return completion(coordinates, nil)
        }
    }
    
    // Устанавливаем карту по координатам
    private func setMapViewCenter(_ coordinates: CLLocationCoordinate2D, radius: Double) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: false)
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
                self.setMapViewCenter(coordinates, radius: self.locationRadius)
            }
        }
    }
}

// MARK: - Show and Hide Map (это делаем для того, чтобы не появлялась пустая карта, а потом она перескакивала на правильный адрес, а так он сразу показывает правильный адрес)
private extension MapView {
    // Прячем карту
    func hideEmptyMap(_ isHidden: Bool) {
        if isHidden { self.mapView.alpha = 0 }
    }

    // Показываем карту
    func showMap() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.mapView.alpha = 1
            }
        }
    }
}
