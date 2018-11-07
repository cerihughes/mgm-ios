import MapKit
import UIKit

/// A view that represents the latest event, and the albums being reviewed
class LatestEventView: DataLoadingView {
    let mapView = MKMapView()
    let collectionView: UICollectionView

    private let spacing: CGFloat = 4.0

    override init(frame: CGRect) {
        let layout = FullWidthCollectionViewLayout(itemHeight: 128.0, spacing: spacing)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        super.init(frame: frame)

        backgroundColor = .white

        mapView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.isHidden = true
        collectionView.accessibilityIdentifier = "mgm:latestEvent:collectionView"

        addSubview(mapView)
        addSubview(collectionView)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: mapView.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                        trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                        topAnchor: safeAreaLayoutGuide.topAnchor,
                                                        heightAnchor: collectionView.heightAnchor, heightMultiplier: 0.5))

        constraints.append(contentsOf: collectionView.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                               trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                               topAnchor: mapView.bottomAnchor, topConstant: spacing,
                                                               bottomAnchor: safeAreaLayoutGuide.bottomAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: API

    func showResults() {
        hideMessage()
        collectionView.isHidden = false
    }

    override func showMessage(_ message: String) {
        super.showMessage(message)
        collectionView.isHidden = true
    }

    func dropPin(at location: CLLocation, title: String) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}
