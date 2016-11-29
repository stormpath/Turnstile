//
//  OAuthDelegator.swift
//  TurnstileWeb
//
//  Created by Kaden Wilkinson on 11/12/16.
//
//

import Foundation
import Turnstile

open class OAuthDelegator {

    public let consumerKey: String
    

    /// Mockable URL Session generator. Should be using epheremal sessions, but doesn't seem to work on linux
    var _urlSession: HTTPClientGenerator = { URLSession(configuration: URLSessionConfiguration.default) }

    /// We don't want URLSessions to store cookies, so we have to generate a new one for each request.
    public var urlSession: HTTPClient {
        return _urlSession()
    }

    /// Creates the OAuthEcho client
    public init(consumerKey: String) {
        self.consumerKey = consumerKey
    }
    
}
