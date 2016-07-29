//
//  Turnstile.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public class Turnstile {
    public let sessionManager: SessionManager
    public let realms: [Realm]
    
    public static var sharedTurnstile: Turnstile!
    
    public init(sessionManager: SessionManager, realms: [Realm]) {
        self.sessionManager = sessionManager
        self.realms = realms
        
        sessionManager.boot(turnstile: self)
    }
    
    public func authenticate(credentials: Credentials) throws -> Account {
        var error: ErrorProtocol?
        
        for realm in realms {
            do {
                return try realm.authenticate(credentials: credentials)
            }
            catch let thrownError {
                error = thrownError
            }
        }
        throw error ?? UnsupportedCredentialsError()
    }
    
    public func register(credentials: Credentials) throws -> Account {
        var error: ErrorProtocol?
        
        for realm in realms {
            do {
                return try realm.register(credentials: credentials)
            }
            catch let thrownError {
                error = thrownError
            }
        }
        throw error ?? UnsupportedCredentialsError()
    }
}
