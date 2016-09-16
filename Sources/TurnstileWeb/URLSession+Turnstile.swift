//
//  URLSession+Turnstile.swift
//  Turnstile
//
//  Created by Edward Jiang on 9/6/16.
//
//

import Foundation
import Dispatch

public protocol HTTPClient {
    func executeRequest(request: URLRequest) throws -> (Data?, URLResponse?)
}

extension URLSession: HTTPClient {
    public func executeRequest(request: URLRequest) throws -> (Data?, URLResponse?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }.resume()
        
        semaphore.wait()
        
        if let error = error {
            throw error
        }
        
        return (data, response)
    }
}
