//
//  Deferred+extension.swift
//  splitViewController
//
//  Created by Pia on 14/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import Deferred

extension Task {
    
    public func recover(upon executor: Executor, start startNextTask: @escaping(Error) -> Task<SuccessValue>) -> Task<SuccessValue> {
        
        let future: Future<TaskResult<SuccessValue>> = andThen(upon: executor) { (result) -> Task<SuccessValue> in
            do {
                let value = try result.extract()
                return Task<SuccessValue>(success: value)
            } catch let error {
                return startNextTask(error)
            }
        }
        
        return Task<SuccessValue>(future: future)
    }
}
