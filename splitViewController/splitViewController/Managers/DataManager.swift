//
//  DataManager.swift
//  splitViewController
//
//  Created by Pia on 14/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import UIKit
import Deferred

class DataManager {
    
    //MARK: - Singleton
    static let manager = DataManager()
    
    //MARK: - Stored properties
    var array = [CellModel]()
    
    //MARK: - Public API
    func feedRow(image: UIImage, text: String, switchValue: Bool) {
        array.append(CellModel(image: image, text: text, switchValue: switchValue))
    }
    
    func fetchCellForRow(_ row: CLong) -> TaskResult<CellModel> {
        
        if array.count > row {
            return .success(array[row])
        } else {
            return .failure(APIError.unableToFetchData)
        }
//        return .success(CellModel(image: UIImage(named: "dog")!, text: "test", switchValue: false))
    }
    
    func updateSwitchForRow(_ row: CLong, newValue: Bool) {
        array[row].switchValue = newValue
    }
}
