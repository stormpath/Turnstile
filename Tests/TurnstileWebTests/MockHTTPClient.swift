//
//  MockHTTPClient.swift
//  Turnstile
//
//  Created by Edward Jiang on 9/14/16.
//
//

import Foundation
@testable import TurnstileWeb

typealias MockHTTPEndpoint = (URLRequest) throws -> (Data?, URLResponse?)

class MockHTTPClient: HTTPClient {
    let endpoint: MockHTTPEndpoint
    
    init(endpoint: @escaping MockHTTPEndpoint) {
        self.endpoint = endpoint
    }
    
    func executeRequest(request: URLRequest) throws -> (Data?, URLResponse?) {
        return try endpoint(request)
    }
}
