//
//  APIKeyCredentials.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/28/16.
//
//

public struct APIKeyCredentials: Credentials {
    public let id: String
    public let secret: String
    
    public init(id: String, secret: String) {
        self.id = id
        self.secret = secret
    }
}
