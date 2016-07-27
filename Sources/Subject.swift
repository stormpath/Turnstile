//
//  Subject.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public class Subject {
    weak var turnstile: Turnstile!
    
    public init(turnstile: Turnstile) {
        self.turnstile = turnstile
    }
    
    public func login(credentials: Credentials) throws {
        if credentials.verify() {
            print("success!")
        } else {
            throw IncorrectCredentialsError()
        }
    }
}

public protocol Credentials {
    func verify() -> Bool
}

public struct UsernamePasswordCredentials: Credentials {
    let username: String
    let password: String
    
    public func verify() -> Bool {
        return password == "TestTest1"
    }
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

public struct IncorrectCredentialsError: ErrorProtocol {}
