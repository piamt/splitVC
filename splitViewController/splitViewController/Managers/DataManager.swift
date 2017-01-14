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
    fileprivate init() { }
    
    //MARK: - Stored properties
    var dictionary = [CLong: CellModel]()
    
    //MARK: - Public API
    func feedRow(_ row: CLong, image: UIImage, text: String, switchValue: Bool, switchEnabled: Bool) {
        dictionary[row] = CellModel(image: image, text: text, switchValue: switchValue, switchEnabled: switchEnabled)
    }
    
    func feedRowLoading(_ row: CLong) {
        dictionary[row] = CellModel()
    }
    
    func feedRowError(_ row: CLong) {
        let model = CellModel()
        model.setupError()
        dictionary[row] = model
    }
    
    func fetchCellForRow(_ row: CLong) -> TaskResult<CellModel> {
        if let element = dictionary[row] {
            return .success(element)
        } else {
            return .failure(APIError.resourceNotFound)
        }
    }
    
    func updateSwitchForRow(_ row: CLong, newValue: Bool) {
        dictionary[row]?.switchValue = newValue
    }
}
