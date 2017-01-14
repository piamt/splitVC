//
//  APIClient.swift
//  splitViewController
//
//  Created by Pia on 12/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Foundation
import Alamofire
import Deferred
import ObjectMapper

enum APIError: Error {
    
    case unableToFetchData
    
    case resourceNotFound
    
    case unknownError
}

class APIClient {
    
    //MARK: - Stored Properties
    static let client = APIClient()
    
    fileprivate init() {
        
    }
    
    //MARK: - Web services
    
    //TODO: When one or both services fails, retry or show error!
    func fetchDataForRow(_ row: CLong, onCompletion: @escaping (TaskResult<Void>) -> Void) {
        fetchRandomText { result in
            switch result {
            case .failure(let error):
                print(error)
                onCompletion(.failure(APIError.unableToFetchData))
            case .success(let text):
                print(text)
                self.fetchRandomImage(onCompletion: { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        onCompletion(.failure(APIError.unableToFetchData))
                    case .success(let image):
                        print(image)
                        
                        DataManager.manager.feedRow(image: image, text: text, switchValue: false)
                        onCompletion(.success())
                    }
                })
            }
        }
    }
    
    fileprivate func fetchRandomText(onCompletion: @escaping (TaskResult<String>) -> Void) {
        
        Alamofire.request("http://schematic-ipsum.herokuapp.com",
                          method: .post,
                          parameters: ["type" : "string"] as [String: Any],
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                let jsonSerializationOptions = JSONSerialization.ReadingOptions.allowFragments
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: jsonSerializationOptions),
                    let text = json as? String
                {
                    print("**** JSON Response:\n\(text)")
                    onCompletion(.success(text))
                } else {
                    onCompletion(.failure(APIError.unableToFetchData))
                }
        }
    }
    
    fileprivate func fetchRandomImage(onCompletion: @escaping (TaskResult<UIImage>) -> Void) {
        let imageURL = URL(string: "http://loremflickr.com/340/340/animals")
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    if imageData != nil,
                        let image = UIImage(data: imageData as! Data) {
                        onCompletion(.success(image as UIImage))
                    } else {
                        onCompletion(.failure(APIError.unableToFetchData))
                    }
                }
            }
        }
    }
}
