//
//  MockURLSession.swift
//  BoxofficeInfoTests
//
//  Created by Andrew, 레옹아범 on 2023/03/22.
//

import Foundation

class StubURLSession: URLSessionProtocol {
    
    var isDeny = false
    let sessionDataTask = FakeURLSessionDataTask()
    
    init(isDeny: Bool = false) {
        self.isDeny = isDeny
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let successResoponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url, statusCode: 410, httpVersion: "2", headerFields: nil)
        
        sessionDataTask.resumeDidCall = {
            if self.isDeny {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(StubBoxoffice().data, successResoponse, nil)
            }
        }
        
        return sessionDataTask
    }
}
