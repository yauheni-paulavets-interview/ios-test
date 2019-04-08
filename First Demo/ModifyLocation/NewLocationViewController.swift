//
//  NewLocationViewController.swift
//  First Demo
//
//  Created by Yauheni Paulavets on 3/23/19.
//  Copyright © 2019 Yauheni Paulavets. All rights reserved.
//

import UIKit
import GooglePlaces

protocol GoBackDelegate {
    func goBack()
}

class NewLocationViewController: UIViewController, GoBackDelegate {
    
    var collapsibleTable: CollapsibleTableViewController!
    var dataPassedWithSegue: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collapsibleTable = CollapsibleTableViewController(style: .grouped, delegate: self)
        if let data = dataPassedWithSegue {
            collapsibleTable.model = LocationModel(data: data)
            dataPassedWithSegue = nil
        }
        view.addSubview(collapsibleTable.tableView)
        let rect = navigationController!.navigationBar.frame;
        let y = rect.size.height
        collapsibleTable.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender!)
        let data = sender as! [String: Any]
        if segue.identifier == "EditLocationSegue" {
            collapsibleTable.model = LocationModel(data: data)
        }
    }
    
    public func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
