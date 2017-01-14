//
//  CellModel.swift
//  splitViewController
//
//  Created by Pia on 14/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import UIKit

class CellModel {
    
    //MARK: - Stored properties
    var image: UIImage
    var text: String
    var switchValue: Bool
    var switchEnabled: Bool
    
    //MARK: - Initializers
    init(image: UIImage = UIImage(named: "dog")!, text: String = "Loading...", switchValue: Bool = false, switchEnabled: Bool = false) {
        self.image = image
        self.text = text
        self.switchValue = switchValue
        self.switchEnabled = switchEnabled
    }
    
    //MARK: - Public API
    func setupError(image: UIImage = UIImage(named: "error")!, text: String = "Unable to fetch data", switchValue: Bool = false, switchEnabled: Bool = false) {
        self.image = image
        self.text = text
        self.switchValue = switchValue
        self.switchEnabled = switchEnabled
    }
}
