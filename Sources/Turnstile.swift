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
}
