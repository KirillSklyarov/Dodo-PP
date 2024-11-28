import UIKit
import MapKit

final class UserTrackingButton: MKUserTrackingButton {

    init(mapView: MKMapView?) {
        super.init(frame: .zero)
        self.mapView = mapView
        backgroundColor = AppColors.backgroundBlack
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
