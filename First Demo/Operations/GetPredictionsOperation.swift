import Foundation
import GooglePlaces

class GetPredictionsOpearion: OperationWithFinnished {
    
    var predictions: Array<GMSAutocompletePrediction> = []
    var placesClient: GMSPlacesClient!
    var searchTerm: String
    
    init(_ searchTerm: String) {
        self.searchTerm = searchTerm
        super.init()
        placesClient = GMSPlacesClient.shared()
    }
    
    override func main() {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        placesClient.autocompleteQuery(self.searchTerm, bounds: nil, boundsMode: GMSAutocompleteBoundsMode.bias, filter: filter, callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            if (results!.count > 0) {
                self.predictions = results!
                self.isFinished = true;
            }
        })
    }
}
