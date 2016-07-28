//
//  Subject.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public class Subject {
    weak var turnstile: Turnstile!
    public var authDetails: AuthenticationDetails?
    
    public var authenticated: Bool {
        return authDetails?.account != nil
    }
    
    public init(turnstile: Turnstile) {
        self.turnstile = turnstile
    }
    
    public func login(credentials: Credentials, persist: Bool = false) throws {
        let account = try turnstile.authenticate(credentials: credentials)
        let sessionID: String? = persist ? turnstile.sessionManager.createSession(subject: self) : nil
        let credentialType = credentials.dynamicType
        
        authDetails = AuthenticationDetails(account: account, sessionID: sessionID, credentialType: credentialType)
    }
    
    public func register(credentials: Credentials) throws {
        try turnstile.register(credentials: credentials)
    }
    
    public func logout() {
        if let sessionIdentifier = authDetails?.sessionID {
            turnstile.sessionManager.deleteSession(identifier: sessionIdentifier)
        }
    }
}

public struct AuthenticationDetails {
    public let account: Account
    public let sessionID: String?
    public let credentialType: Credentials.Type
}
