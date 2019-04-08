import UIKit

public protocol CollectionViewCellTappedDelegate {
    func tapped(data: [String: Any])
}

public class LocationsGridViewController: UICollectionViewController {
    
    let getLocationsQueue = DispatchQueue(label: "persistInfo")
    let getLocationsOperationsQueue = OperationQueue()
    
    public var places: [String] = []
    public var placeIdToPersons: [String: [LocationFlatModel]] = [:]

    @IBOutlet weak var gridLayout: StickyGridCollectionViewLayout! {
        didSet {
            gridLayout.stickyColumnsCount = 1
        }
    }
    
    public var tapDelegate: CollectionViewCellTappedDelegate?
    
    public override func viewDidLoad() {
        if let collectionView = collectionView {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.bounces = false
            edgesForExtendedLayout = UIRectEdge.bottom
            
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        }
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return places.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let placeId = places[section]
        return placeIdToPersons[placeId]!.count + 1
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        if !places.isEmpty {
            let placeId = places[indexPath.section]
            var column = indexPath.item
            column = column > 0 ? column - 1 : column
            if placeIdToPersons[placeId]!.count >= column {
                let locationData: LocationFlatModel
                if let locations = placeIdToPersons[placeId] {
                    locationData = locations[column]
                    cell.setView(isSideBar: gridLayout.isItemSticky(at: indexPath), locationData: locationData)
                }
            }
        }
        
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > 0 {
            let placeId = places[indexPath.section]
            guard let locations = placeIdToPersons[placeId] else {
                return
            }
            
            let column = indexPath.item - 1
            if tapDelegate != nil && locations.count > column {
                let data = locations[column].dataDict
                tapDelegate!.tapped(data: data)
            }
        }
    }
}

extension LocationsGridViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
