import MapKit
import SnapKit
import UIKit

class LatestEventLocationCollectionViewCell: UICollectionViewCell {
    private let mapView = MKMapView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        mapView.isUserInteractionEnabled = false

        contentView.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

    // MARK: API

    func dropPin(at location: CLLocation, title: String) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 200,
            longitudinalMeters: 200
        )
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}
