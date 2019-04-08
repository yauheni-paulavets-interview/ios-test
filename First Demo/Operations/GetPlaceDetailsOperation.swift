import Foundation
import GooglePlaces

class GetPlaceDetailsOperation: OperationWithFinnished {
    
    var coordinates: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient!
    var prediction: GMSAutocompletePrediction
    
    init(_ prediction: GMSAutocompletePrediction) {
        self.prediction = prediction
        super.init()
        placesClient = GMSPlacesClient.shared()
    }
    
    override func main() {
        placesClient.lookUpPlaceID(prediction.placeID!, callback: { (place, error) in
            if let error = error {
                print("Get details error: \(error)")
                return
            }
            self.coordinates = place!.coordinate
            self.isFinished = true
        })
    }
}
