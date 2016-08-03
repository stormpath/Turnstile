//
//  Turnstile.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public class Turnstile {
    public let sessionManager: SessionManager
    public let realm: Realm
    
    public static var sharedTurnstile: Turnstile!
    
    public init(sessionManager: SessionManager, realm: Realm) {
        self.sessionManager = sessionManager
        self.realm = realm
        
        sessionManager.boot(turnstile: self)
    }
    
    public func createUser() -> User {
        return User(turnstile: self)
    }
}
