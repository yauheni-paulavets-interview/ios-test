import UIKit
import GooglePlaces

class CollapsibleTableViewController: UITableViewController {
    
    var model: LocationModel = LocationModel()
    
    let pesistInfoOperationsQueue = OperationQueue()
    var placesClient: GMSPlacesClient!
    
    var delegate: GoBackDelegate
    
    init(style: UITableViewStyle, delegate: GoBackDelegate) {
        self.delegate = delegate
        super.init(style: style)
        placesClient = GMSPlacesClient.shared()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // WHY it's stretched??
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        customView.backgroundColor = UIColor.red
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        customView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        tableView.tableFooterView = customView;
        
        // To hide gaps between sections
        tableView.sectionFooterHeight = 0.0;
        
        self.title = "Apple Products"
        tableView.allowsSelection = false
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        let locationSectionData = model.getSection(index: 1) as! LocationSectionModel
        placesClient.lookUpPlaceID(locationSectionData.placeId, callback: { [weak self] (place, error) in
            guard let weakself = self else {return}
            if let error = error {
                print("Get details error: \(error)")
                return
            }
            locationSectionData.coordinates = place?.coordinate
            let data = weakself.model.buildPayload()
            let modifyLocation = ModifyLocationOperation(data: data)
            weakself.pesistInfoOperationsQueue.addOperations([modifyLocation], waitUntilFinished: true)
            weakself.model.reset()
            weakself.delegate.goBack()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsibleTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.getNumberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getSection(index: section).collapsed ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section: SectionModel = model.getSection(index: indexPath.section)
        let cell: CustomSection!
        // To simplify - always create new section with the same id
        switch section.identifier {
        case .locationSection:
//            cell = tableView.dequeueReusableCell(withIdentifier: section.identifier.rawValue) as? CustomSection ??
//                LocationSection(style: .default, reuseIdentifier: section.identifier.rawValue, section: section)
            cell = LocationSection(style: .default, reuseIdentifier: section.identifier.rawValue, section: section)
        case .personalSection:
            cell = PersoanlInfoSection(style: .default, reuseIdentifier: section.identifier.rawValue, section: section)
        }
        cell.setParentTable(self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = model.getSection(index: section).name
        header.arrowLabel.text = ">"
        header.setCollapsed(model.getSection(index: section).collapsed)
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}

//
// MARK: - Section Header Delegate
//
extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !model.getSection(index: section).collapsed
        
        // Toggle collapse
        model.getSection(index: section).collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
