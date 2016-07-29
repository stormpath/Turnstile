//
//  TokenCredentials.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/28/16.
//
//

public struct TokenCredentials: Credentials {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
}
