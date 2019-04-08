//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//
import UIKit
import GooglePlaces

protocol LocationSelectedDelegate {
    func selectLocation(_ prediction: GMSAutocompletePrediction)
}

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
//    override var intrinsicContentSize: CGSize {
//        let height = min(contentSize.height, maxHeight)
//        return CGSize(width: contentSize.width, height: height)
//    }
}

//
// MARK: - View Controller
//
class LocationsTable: UITableViewController {
    
    var delegate: LocationSelectedDelegate!
    var predictions: Array<GMSAutocompletePrediction> = []
    
    override func loadView() {
        tableView = SelfSizedTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = "Apple Products"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prediction: GMSAutocompletePrediction = predictions[indexPath.row]
        delegate.selectLocation(prediction)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell") ?? UITableViewCell(style: .default, reuseIdentifier: "PredictionCell")
        
        let prediction: GMSAutocompletePrediction = predictions[indexPath.row]
        cell.textLabel!.numberOfLines = 0;
        cell.textLabel!.lineBreakMode = .byWordWrapping;
        cell.textLabel!.text = prediction.attributedFullText.string
        
        return cell
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
//            dataController.modify(note: notes[indexPath.row], task: .delete)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//final class CustomTableView: UITableView {
//
//    private var predictions: Array<GMSAutocompletePrediction> = []
//
//    func reload(with data: [GMSAutocompletePrediction]) {
//        predictions = data
//
//        reload
//    }
//}
