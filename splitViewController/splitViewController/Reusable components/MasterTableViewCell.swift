//
//  MasterTableViewCell.swift
//  splitViewController
//
//  Created by Pia Muñoz on 11/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Foundation
import UIKit

protocol SynchroDelegate: class {
    func switchValueForRow(_ row: CLong, value: Bool)
    func dataReloadForRow(_ row: CLong, image: UIImage, text: String, switchValue: Bool)
}

class MasterTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var randomLabel: UILabel!
    @IBOutlet weak var customSwitch: UISwitch!
    
    //MARK: - Stored Properties
    weak var delegate: SynchroDelegate? = nil
    var rowNumber: CLong? = nil
    
    //MARK: - Public API
    func drawCell(row: CLong, image: UIImage, text: String, switchValue: Bool) {
        rowNumber = row
        randomImage.image = nil
        randomImage.image = image
        randomLabel.text = text
        randomLabel.font = UIFont.systemFont(ofSize: 14)
        customSwitch.setOn(switchValue, animated: false)
        customSwitch.isUserInteractionEnabled = true
        dedailReload(image: image, text: text, switchValue: switchValue)
    }
    
    func loadingCell(row: CLong) {
        drawCell(row: row, image: UIImage(named: "dog")!, text: "Loading...", switchValue: false)
        customSwitch.isUserInteractionEnabled = false
    }
    
    //MARK: - Delegate methods
    @IBAction func switchValueChanged(_ sender: Any) {
        let switchObject = sender as! UISwitch
        DataManager.manager.updateSwitchForRow(rowNumber!, newValue: switchObject.isOn)
        self.delegate?.switchValueForRow(rowNumber!, value: switchObject.isOn)
    }
    
    func dedailReload(image: UIImage, text: String, switchValue: Bool) {
        self.delegate?.dataReloadForRow(rowNumber!, image: image, text: text, switchValue: switchValue)
    }
}
