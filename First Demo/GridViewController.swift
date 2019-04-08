import UIKit
import StickyCollectionView

class GridViewController: UIViewController, CollectionViewCellTappedDelegate {
    
    let getLocationsQueue = DispatchQueue(label: "persistInfo")
    let getLocationsOperationsQueue = OperationQueue()
    
    var customCollectionView: LocationsGridViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        customCollectionView = LocationsGridViewController(nibName: "StickyCollectionView", bundle: Bundle(identifier: "demo.first.StickyCollectionView"))
        customCollectionView.tapDelegate = self
        customCollectionView.collectionView!.frame = view.bounds
        customCollectionView.collectionView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(customCollectionView.collectionView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _fetchAdnRenderLocations();
    }
    
    func _fetchAdnRenderLocations() {
        var places: [String] = []
        var placeIdToPersons: [String: [LocationFlatModel]] = [:]
        getLocationsQueue.async { [weak self] in
            guard let weakself = self else {return}
            let getLocations = GetLocationsOpearion()
            
            weakself.getLocationsOperationsQueue.addOperations([getLocations], waitUntilFinished: true)
            if !getLocations.data.isEmpty {
                for jsonLocation in getLocations.data {
                    let location = LocationFlatModel(data: jsonLocation)
                    let placeId = jsonLocation["placeId"] as! String
                    if !places.contains(placeId) {
                        places.append(placeId)
                    }
                    if placeIdToPersons[placeId] != nil {
                        placeIdToPersons[placeId]!.append(location)
                    } else {
                        placeIdToPersons.updateValue([location], forKey: placeId)
                    }
                }
                
                weakself.customCollectionView.places = places
                weakself.customCollectionView.placeIdToPersons = placeIdToPersons
                
                DispatchQueue.main.async {
                    weakself.customCollectionView.collectionView!.reloadData()
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
    
    func tapped(data: [String: Any]) {
        performSegue(withIdentifier: "EditLocationSegue", sender: data)
    }
}
