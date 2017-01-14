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
    
    //MARK: - Public API
    init(image: UIImage, text: String, switchValue: Bool) {
        self.image = image
        self.text = text
        self.switchValue = switchValue
    }
}
