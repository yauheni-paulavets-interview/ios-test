import Foundation

public class LocationFlatModel {
    var firstName: String
    var lastName: String
    var dateStr: String
    var addressValue: String
    var longitude: Double
    var latitude: Double
    var placeId: String
    var dataDict: [String: Any]
    
    public init(data: [String: Any]) {
        addressValue = data["adress"] as! String
        placeId = data["placeId"] as! String
        longitude = data["longitude"]  as! Double
        latitude = data["latitude"]  as! Double
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        dateStr = data["dateStr"] as! String
        dataDict = data
    }
}

