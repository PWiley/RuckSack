//
//  URLSessionWeatherFake.swift
//  RuckSackTests
//
//  Created by Patrick Wiley on 07.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

class URLSessionWeatherFake: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionWeatherTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionWeatherTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
}

class URLSessionWeatherTaskFake: URLSessionDataTask {
    
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    
    
    override func resume() {
        completionHandler?(data, urlResponse, error)
    }
    override func cancel() {}
}
