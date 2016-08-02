//
//  PasswordCredentials.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/27/16.
//
//

public struct PasswordCredentials: Credentials {
    public let username: String
    public let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
