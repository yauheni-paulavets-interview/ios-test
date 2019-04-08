import Foundation
import GooglePlaces

public enum SectionIdentifier: String {
    case locationSection = "location_section"
    case personalSection = "personal_section"
}

public class SectionModel {
    public var name: String
    public var identifier: SectionIdentifier
    public var collapsed: Bool
    
    init(identifier: SectionIdentifier, name: String, collapsed: Bool = false) {
        self.name = name
        self.identifier = identifier
        self.collapsed = collapsed
    }
    
    func buildPayload() -> [String: Any] {
        return [:];
    }
    
    func reset() {
        collapsed = false
    }
}

public class LocationSectionModel: SectionModel {
    var predictions: Array<GMSAutocompletePrediction> = []
    var addressValue: String = ""
    var coordinates: CLLocationCoordinate2D!
    var placeId: String!
    
    override init(identifier: SectionIdentifier, name: String, collapsed: Bool = false) {
        super.init(identifier: identifier, name: name, collapsed: collapsed)
    }
    
    convenience init(data: [String: Any], identifier: SectionIdentifier, name: String, collapsed: Bool = false) {
        self.init(identifier: identifier, name: name, collapsed: collapsed)
        addressValue = data["adress"] as! String
        placeId = data["placeId"] as! String
        coordinates = CLLocationCoordinate2D(latitude: data["latitude"]  as! Double, longitude: data["longitude"]  as! Double)
    }
    
    override func buildPayload() -> [String: Any] {
        return ["adress" : addressValue,
                "longitude"   : coordinates.longitude,
                "latitude" : coordinates.latitude,
                "placeId": placeId]
    }
    
    override func reset () {
        super.reset()
        addressValue = ""
        coordinates = nil
        placeId = nil
        predictions = []
    }
}

public class PersonalSectionModel: SectionModel {
    var firstName: String = ""
    var lastName: String = ""
    var dateStr: String = ""
    
    override init(identifier: SectionIdentifier, name: String, collapsed: Bool = false) {
        super.init(identifier: identifier, name: name, collapsed: collapsed)
    }
    
    convenience init(data: [String: Any], identifier: SectionIdentifier, name: String, collapsed: Bool = false) {
        self.init(identifier: identifier, name: name, collapsed: collapsed)
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        dateStr = data["dateStr"] as! String
    }
    
    override func buildPayload() -> [String: Any] {
        return ["firstName" : firstName,
                "lastName"   : lastName,
                "dateStr" : dateStr]
    }
    
    override func reset () {
        super.reset()
        firstName = ""
        lastName = ""
        dateStr = ""
    }
}

public class LocationModel {
    var recordId: String
    var sectionsData: [SectionModel]
    
    init(recordId: String = "") {
        self.recordId = recordId
        self.sectionsData = [
            PersonalSectionModel(identifier: SectionIdentifier.personalSection, name: "Personal"),
            LocationSectionModel(identifier: SectionIdentifier.locationSection, name: "Location")
        ]
    }
    
    init(data: [String: Any]) {
        recordId = data["id"] as! String
        let personalInfoSection = PersonalSectionModel(data: data, identifier: SectionIdentifier.personalSection, name: "Personal")
        let locationSectionModel = LocationSectionModel(data: data, identifier: SectionIdentifier.locationSection, name: "Location")
        sectionsData = []
        sectionsData.append(personalInfoSection)
        sectionsData.append(locationSectionModel)
    }
    
    func buildPayload() -> [String: Any] {
        var data: [String: Any] = [:]
        for section in sectionsData {
            data.merge(dict: section.buildPayload())
        }
        data["id"] = recordId
        return data
    }
    
    func reset() {
        for section in sectionsData {
            section.reset()
        }
    }
    
    func getSection(index: Int) -> SectionModel {
        return sectionsData[index]
    }
    
    func getNumberOfSections() -> Int {
        return sectionsData.count
    }
}

public var sectionsData: [SectionModel] = [
    PersonalSectionModel(identifier: SectionIdentifier.personalSection, name: "Personal"),
    LocationSectionModel(identifier: SectionIdentifier.locationSection, name: "Location")
]
