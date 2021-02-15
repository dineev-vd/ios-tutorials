//
//  RouteTableViewController.swift
//  MapKitDirection
//
//  Created by Влад Динеев on 15.02.2021.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class RouteTableViewController: UITableViewController {
    var routeSteps = [MKRoute.Step]()
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:
                                                    indexPath)
        // Configure the cell...
        cell.textLabel?.text = routeSteps[indexPath.row].instructions
        return cell
    }
}
