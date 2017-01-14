//
//  String+extension.swift
//  splitViewController
//
//  Created by Pia on 13/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
