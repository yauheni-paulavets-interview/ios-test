import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var stackLayout: UIStackView!
    
    let getLocationsQueue = DispatchQueue(label: "persistInfo")
    let getLocationsOperationsQueue = OperationQueue()
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _renderMapWithRandomAddress();
    }
    
    func _renderMapWithRandomAddress() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.userData = nil
        marker.map = mapView
        
        stackLayout.addArrangedSubview(mapView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _fetchAdnRenderLocations();
    }
    
    func _fetchAdnRenderLocations() {
        getLocationsQueue.async { [weak self] in
            guard let weakself = self else {return}
            let getLocations = GetLocationsOpearion()
            
            weakself.getLocationsOperationsQueue.addOperations([getLocations], waitUntilFinished: true)
            DispatchQueue.main.async {
                var bounds = GMSCoordinateBounds()
                if !getLocations.data.isEmpty {
                    for jsonLocation in getLocations.data {
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: jsonLocation["latitude"]  as! Double, longitude: jsonLocation["longitude"]  as! Double)
                        let firstName = jsonLocation["firstName"] as! String;
                        let lastName = jsonLocation["lastName"] as! String
                        let text: String? = nil
                        print("\(firstName) \(lastName)", "", "", text)
                        marker.title = text
                        marker.snippet = text
                        marker.map = weakself.mapView
                        marker.userData = jsonLocation
                        bounds = bounds.includingCoordinate(marker.position)
                    }
                    let camera = weakself.mapView.camera(for: bounds, insets: UIEdgeInsets())!
                    weakself.mapView.camera = camera
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender!)
        if let data = sender as? [String: Any] {
            if segue.identifier == "EditLocationSegue" && segue.destination is NewLocationViewController {
                let vc = segue.destination as! NewLocationViewController
                vc.dataPassedWithSegue = data
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        performSegue(withIdentifier: "EditLocationSegue", sender: marker.userData)
        return true
    }
}

