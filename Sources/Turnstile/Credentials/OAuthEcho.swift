//
//  OAuthEcho.swift
//  Turnstile
//
//  Created by Kaden Wilkinson on 11/12/16.
//
//

import Foundation

public class OAuthEcho: Credentials {
    public let requestURL: URL
    public let authorizationHeader: String

    public init(requestURL: URL, authorizationHeader: String) {
        self.requestURL = requestURL
        self.authorizationHeader = authorizationHeader
    }
}
