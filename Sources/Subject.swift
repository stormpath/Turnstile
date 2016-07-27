//
//  Subject.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public class Subject {
    weak var turnstile: Turnstile!
    public var account: Account?
    public var sessionIdentifier: String?
    
    public var authentiated: Bool {
        return account != nil
    }
    
    public init(turnstile: Turnstile) {
        self.turnstile = turnstile
    }
    
    public func login(credentials: Credentials) throws {
        account = try turnstile.authenticate(credentials: credentials)
    }
    
    public func logout() {
        if let sessionIdentifier = sessionIdentifier {
            turnstile.sessionManager.deleteSession(identifier: sessionIdentifier)
        }
    }
}

public protocol Credentials {
}

public struct UsernamePasswordCredentials: Credentials {
    let username: String
    let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

public struct IncorrectCredentialsError: ErrorProtocol {}
