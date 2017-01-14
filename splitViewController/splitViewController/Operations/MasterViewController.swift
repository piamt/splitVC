//
//  MasterViewController.swift
//  splitViewController
//
//  Created by Pia Muñoz on 11/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import UIKit
import Deferred

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    //MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if self.tableView.indexPathForSelectedRow != nil {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                if let cell = sender as? MasterTableViewCell {
                    controller.textItem = cell.randomLabel.text
                    controller.imageItem = cell.randomImage.image
                    controller.switchItem = cell.customSwitch.isOn
                    cell.delegate = controller
                }
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
        let rowNumber = indexPath.row
        //First look for the row in Core Data
        let cellResult = CoreDataManager.manager.fetchCellForRow(rowNumber)
        switch cellResult {
        case .success(let entity):
            cell.drawCell(row: rowNumber, image: UIImage(data: entity.imageData as! Data)!,
                            text: entity.text!, switchValue: entity.switchValue)
        case .failure( _):
            // If never displayed:
            // 1. Draw cell "loading"
            cell.loadingCell(row: rowNumber)
            // 2. Request APIClient for new data (text and image), store it and display
            askProviderForRow(rowNumber)
        }
        return cell
    }
    
    //MARK: - Core Data
    func askProviderForRow(_ rowNumber: CLong) {
        APIClient.client.fetchDataForRow(rowNumber) { _ in
            // 3. When new data arrives, reload table view
            self.tableView.reloadData()
        }
    }
}
