//
//  MasterViewController.swift
//  splitViewController
//
//  Created by Pia Muñoz on 11/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import UIKit
import Deferred

protocol DetailDelegate: class {
    func dataReloadForRow(_ row: CLong, image: UIImage, text: String, switchValue: Bool)
}

class MasterViewController: UITableViewController {

    //MARK: - Stored properties
    var detailViewController: DetailViewController? = nil
    weak var delegate: DetailDelegate? = nil
    var currentRowNumber = 0

    //MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //API setup
        APIClient.client.setup(imageTopic: "music", numberOfTries: 3)
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
                    controller.rowNumber = cell.rowNumber
                    controller.textItem = cell.randomLabel.text
                    controller.imageItem = cell.randomImage.image
                    controller.switchItem = cell.customSwitch.isOn
                    cell.delegate = controller
                    self.delegate = controller
                    currentRowNumber = cell.rowNumber!
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
        //First look for the row in Data Manager
        let cellResult = DataManager.manager.fetchCellForRow(rowNumber)
        switch cellResult {
        case .success(let model):
            cell.drawCell(row: rowNumber, image: model.image, text: model.text, switchValue: model.switchValue, switchEnabled: model.switchEnabled)
        case .failure( _):
            // If never displayed:
            // 1. Draw loading cell
            cell.loadingCell(row: rowNumber)
            // 2. Request APIClient for new data
            askProviderForRow(rowNumber)
        }
        return cell
    }
    
    //MARK: - Data Manager
    func askProviderForRow(_ rowNumber: CLong) {
        APIClient.client.requestDataForRow(rowNumber) { result in
            // 3. When new data arrives, reload table view and detail
             self.tableView.reloadData()
            switch result {
            case .success(let model):
                self.detailReload(rowNumber: rowNumber, image: model.image, text: model.text, switchValue: model.switchValue, switchEnabled: model.switchEnabled)
            case .failure( _):
                break
            }
        }
    }
    
    //MARK: - Delegate methods
    func detailReload(rowNumber: CLong, image: UIImage, text: String, switchValue: Bool, switchEnabled: Bool) {
        if rowNumber == currentRowNumber {
            self.delegate?.dataReloadForRow(rowNumber, image: image, text: text, switchValue: switchValue)
        }
    }
}
