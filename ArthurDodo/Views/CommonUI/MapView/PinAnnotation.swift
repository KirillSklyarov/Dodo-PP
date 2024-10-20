//
//  PinAnnotation.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 20.10.2024.
//

import MapKit

final class PinAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
