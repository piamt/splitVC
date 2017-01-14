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
    func switchValueChangedTo(_ value: Bool)
}

class MasterTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var randomLabel: UILabel!
    @IBOutlet weak var customSwitch: UISwitch!
    
    //MARK: - Stored Properties
    weak var delegate: SynchroDelegate? = nil
    
    //MARK: - Public API
    func drawCell(row: CLong, image: UIImage, text: String, switchValue: Bool) {
        randomImage.image = nil
        randomImage.image = image
        randomLabel.text = text
        randomLabel.font = UIFont.systemFont(ofSize: 14)
        customSwitch.setOn(switchValue, animated: false)
        customSwitch.restorationIdentifier = "\(row)"
        customSwitch.isUserInteractionEnabled = true
    }
    
    func loadingCell(row: CLong) {
        drawCell(row: row, image: UIImage(named: "dog")!, text: "Loading...", switchValue: false)
        customSwitch.isUserInteractionEnabled = false
    }
    
    func disableSwitch() {
        customSwitch.isUserInteractionEnabled = false
    }
    
    func enableSwitch() {
        customSwitch.isUserInteractionEnabled = true
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        let switchObject = sender as! UISwitch
        CoreDataManager.manager.updateSwitchForRow(CLong(switchObject.restorationIdentifier!)!, newValue: switchObject.isOn)
        
        self.delegate?.switchValueChangedTo(switchObject.isOn)
    }
}
