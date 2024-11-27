import UIKit
import MapKit

final class EditAddressMapView: UIView {

    // MARK: - UI Properties
    private lazy var mapView = MKMapView()
    private lazy var userTrackingButton = UserTrackingButton(mapView: mapView)
    private lazy var pinView = AppImageView(viewImage: AppImages.common(.mapPin), tintColor: .buttonOrange, squareSize: pinImageSize)

    // MARK: - Other properties
    private let rightInset: CGFloat = -20
    private let bottomInset: CGFloat = -20
    private let pinImageSize: CGFloat = 40
    private let locationRadius: CLLocationDistance = 500

    private var isAnimating = false
    private let geocoder = CLGeocoder()

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

// MARK: - Public methods
extension EditAddressMapView {
    // Показываем адрес на карте
    func showAddressOnMap(_ address: Address) {
        let shortAddress = address.cityStreetHouse
        getCoordinates(from: shortAddress) { [weak self] coordinates, error in // Получаем координаты
            guard let self, let coordinates else { print("123"); return }
            showMap() // Показываем карту
            setMapViewCenter(coordinates, radius: locationRadius) // Показываем карту по координатам
        }
    }
}

// MARK: - Setup UI
private extension EditAddressMapView {
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
private extension EditAddressMapView {
    func setupMapView() {
        mapView.delegate = self
    }
}

// MARK: - Setup Animation
private extension EditAddressMapView {
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

// MARK: - MKMapViewDelegate
extension EditAddressMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapCenter = mapView.centerCoordinate
        showPinAnimation()
        getAddress(from: mapCenter)
    }
}

// MARK: - Get Address from coordinates
private extension EditAddressMapView {
    // Получаем адрес из координат и передаем его для обновления таблицы
    func getAddress(from coordinates: CLLocationCoordinate2D) {
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { [weak self] placemarks, error in
            guard let self else { return }
            if let error = error {
                print("Error: \(error.localizedDescription)"); return }

            guard let placemark = placemarks?.first else {
                print("No placemark found"); return }

            let newShortAddress = getAddress(from: placemark)
            onChangeAddress?(newShortAddress)
        }
    }
}

// MARK: - Show and Hide Map (это делаем для того, чтобы не появлялась пустая карта, а потом она перескакивала на правильный адрес, а так он сразу показывает правильный адрес)
private extension EditAddressMapView {
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

// MARK: - Supporting methods
private extension EditAddressMapView {
    // Получаем город, улицу, дом и убираем nil (с помощью compactMap)
    func getAddress(from placemark: CLPlacemark) -> String {
        let components = [placemark.locality, placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }
        // Склеиваем массив в строку
        let newAddress = components.joined(separator: ", ")
        return newAddress
    }

    // Получаем координаты из адреса
    func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
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
    func setMapViewCenter(_ coordinates: CLLocationCoordinate2D, radius: Double) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: false)
    }
}
