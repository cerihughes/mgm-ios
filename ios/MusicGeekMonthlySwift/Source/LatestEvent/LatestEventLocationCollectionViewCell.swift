import MapKit
import UIKit

class LatestEventLocationCollectionViewCell: UICollectionViewCell {
    private let mapView = MKMapView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isUserInteractionEnabled = false

        contentView.addSubview(mapView)

        let constraints: [NSLayoutConstraint] = mapView.anchorTo(view: contentView)
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: API

    func dropPin(at location: CLLocation, title: String) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}
