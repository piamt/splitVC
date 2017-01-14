//
//  RequestDataInteractor.swift
//  splitViewController
//
//  Created by Pia on 14/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Foundation
import Deferred
import Alamofire

class RequestDataInteractor {
    
    //MARK: - Singleton
    static let interactor = RequestDataInteractor()
    private init() { }
    
    //MARK: - Public API
    func requestDataForRow(_ row: CLong, numberOfTries: Int, textUrl: String, imageUrl: String) -> Task<(Void)> {
        
        return fetchDataForRow(row, textUrl: textUrl, imageUrl: imageUrl).recover(upon: DispatchQueue.main) { error -> Task<(Void)> in
            guard numberOfTries > 0 else {
                return Task(failure: APIError.unableToFetchData)
            }
            
            return self.requestDataForRow(row, numberOfTries: numberOfTries - 1, textUrl: textUrl, imageUrl: imageUrl)
        }
    }
    
    func fetchDataForRow(_ row: CLong, textUrl: String, imageUrl: String) -> Task<(Void)> {
        let deferred = Deferred<TaskResult<()>>()
        
        fetchRandomText(textUrl: textUrl) { result in
            switch result {
            case .failure(let error):
                deferred.fill(with: .failure(error))
            case .success(let text):
                self.fetchRandomImage(imageUrl: imageUrl) { result in
                    switch result {
                    case .failure(let error):
                        deferred.fill(with: .failure(error))
                    case .success(let image):
                        DataManager.manager.feedRow(row, image: image, text: text, switchValue: false, switchEnabled: true)
                        deferred.fill(with: .success(()))
                    }
                }
            }
        }
        return Task(future: Future(deferred))
    }
    
    //MARK: - Private API
    fileprivate func fetchRandomText(textUrl: String, onCompletion: @escaping (TaskResult<String>) -> Void) {
        
        Alamofire.request(textUrl,
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
    
    fileprivate func fetchRandomImage(imageUrl: String, onCompletion: @escaping (TaskResult<UIImage>) -> Void) {
        let imageURL = URL(string: imageUrl)
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
