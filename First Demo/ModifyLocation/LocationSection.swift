//
//  CollapsibleTableViewCell.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 7/17/17.
//  Copyright © 2017 Yong Su. All rights reserved.
//
import UIKit
import GooglePlaces

class CustomSection: UITableViewCell {
    var parentTable: CollapsibleTableViewController!
    func setParentTable(_ parentTable: CollapsibleTableViewController) {
        self.parentTable = parentTable
    }
}

class LocationSection: CustomSection, LocationSelectedDelegate {
    
    let stackLayout = UIStackView()
    var resultsTable: UITableView!
    let input = BottomBorderTextField()
    var placesClient: GMSPlacesClient!
    var locationsTable: LocationsTable!
    var section: LocationSectionModel
    
    // MARK: Initalizers
    init(style: UITableViewCellStyle, reuseIdentifier: String?, section: SectionModel) {
        self.section = section as! LocationSectionModel
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        placesClient = GMSPlacesClient.shared()
        
        locationsTable = LocationsTable()
        locationsTable.delegate = self
        locationsTable.predictions = self.section.predictions
        resultsTable = locationsTable.tableView
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        
        let marginGuide = contentView.layoutMarginsGuide;
        
        input.text = self.section.addressValue
        input.placeholder = "Location"
        contentView.addSubview(input)
        contentView.addSubview(resultsTable)
        input.translatesAutoresizingMaskIntoConstraints = false
        input.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        input.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        input.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        
        resultsTable.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        resultsTable.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        resultsTable.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 5.0).isActive = true
        resultsTable.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        resultsTable.isHidden = self.section.predictions.count > 0 ? false : true
        
        input.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        section.addressValue = textField.text!
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        placesClient.autocompleteQuery(textField.text!, bounds: nil, boundsMode: GMSAutocompleteBoundsMode.bias, filter: filter, callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            if (results!.count > 0) {
                DispatchQueue.main.async {
                    self.section.predictions = results!
                    self.locationsTable.predictions = results!
                    self.resultsTable.reloadData()
                    self.resultsTable.isHidden = false
                    self.parentTable.tableView.beginUpdates()
                    self.parentTable.tableView.endUpdates()
                }
            }
        })
    }
    
    func selectLocation(_ prediction: GMSAutocompletePrediction) {
        input.text = prediction.attributedFullText.string
        resultsTable.isHidden = true
        self.locationsTable.predictions = []
        section.predictions = []
        section.addressValue = input.text!
        section.placeId = prediction.placeID
        self.resultsTable.reloadData()
        parentTable.tableView.beginUpdates()
        parentTable.tableView.endUpdates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
