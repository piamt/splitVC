//
//  APIClient.swift
//  splitViewController
//
//  Created by Pia on 12/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Foundation
import Deferred

enum APIError: Error {
    
    case unableToFetchData
    
    case retryFailure
    
    case resourceNotFound
}

class APIClient {
    
    //MARK: - Singleton
    static let client = APIClient()
    fileprivate init() { }
    
    //MARK: - Stored Properties
    var textUrl: String?
    var imageUrl: String?
    var numberOfTries: Int?
    
    //MARK: - Web service setup
    func setup(textUrl: String = "http://schematic-ipsum.herokuapp.com", imageUrl: String = "http://loremflickr.com/340/340", imageTopic: String = "animals", numberOfTries: Int = 3) {
        
        self.textUrl = textUrl
        self.imageUrl = "\(imageUrl)/\(imageTopic)"
        self.numberOfTries = numberOfTries
    }
    
    //MARK: - Web service requests
    func requestDataForRow(_ row: CLong, onCompetion: @escaping (TaskResult<CellModel>) -> Void) {
        DataManager.manager.feedRowLoading(row)
        
        let task = RequestDataInteractor.interactor.requestDataForRow(row, numberOfTries: numberOfTries!, textUrl: textUrl!, imageUrl: imageUrl!)
        let finalTask = task.recover(upon: DispatchQueue.main) { error -> Task<(Void)> in
            return Task(failure: APIError.retryFailure)
        }
        
        finalTask.upon(DispatchQueue.main, execute: { result in
            switch result {
            case .failure( _):
                //We have been unable to load the data
                DataManager.manager.feedRowError(row)
                onCompetion(DataManager.manager.fetchCellForRow(row))
            case .success( _):
                onCompetion(DataManager.manager.fetchCellForRow(row))
            }
        }) 
    }
}
