//
//  Turnstile.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

/**
 Turnstile is the object that manages all components used in Turnstile, and 
 allows them to interoperate.
 */
public class Turnstile {
    /// The session manager backing Turnstile.
    public let sessionManager: SessionManager
    
    /// The realm backing Turnstile
    public let realm: Realm
    
    /// Initialize Turnstile with a compatible session manager and realm.
    public init(sessionManager: SessionManager, realm: Realm) {
        self.sessionManager = sessionManager
        self.realm = realm
    }
}
