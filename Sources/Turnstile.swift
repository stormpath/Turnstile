//
//  Turnstile.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public class Turnstile {
    public let sessionManager: SessionManager
    public static var sharedTurnstile: Turnstile!
    
    public init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        
        sessionManager.boot(turnstile: self)
    }
}
