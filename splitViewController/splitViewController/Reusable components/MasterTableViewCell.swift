//
//  MasterTableViewCell.swift
//  splitViewController
//
//  Created by Pia Muñoz on 11/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Foundation
import UIKit

protocol SwitchDelegate: class {
    func switchValueForRow(_ row: CLong, value: Bool)
}

class MasterTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var randomLabel: UILabel!
    @IBOutlet weak var customSwitch: UISwitch!
    
    //MARK: - Stored Properties
    weak var delegate: SwitchDelegate? = nil
    var rowNumber: CLong? = nil
    
    //MARK: - Public API
    func drawCell(row: CLong, image: UIImage, text: String, switchValue: Bool, switchEnabled: Bool) {
        rowNumber = row
        randomImage.image = nil
        randomImage.image = image
        randomLabel.text = text
        customSwitch.setOn(switchValue, animated: false)
        customSwitch.isUserInteractionEnabled = switchEnabled
    }
    
    func loadingCell(row: CLong) {
        drawCell(row: row, image: UIImage(named: "dog")!, text: "Loading...", switchValue: false, switchEnabled: false)
    }
    
    //MARK: - Delegate methods
    @IBAction func switchValueChanged(_ sender: Any) {
        let switchObject = sender as! UISwitch
        DataManager.manager.updateSwitchForRow(rowNumber!, newValue: switchObject.isOn)
        self.delegate?.switchValueForRow(rowNumber!, value: switchObject.isOn)
    }
}
