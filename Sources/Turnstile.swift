//
//  Turnstile.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public class Turnstile {
    let sessionManager: SessionManager
    static var sharedTurnstile: Turnstile!
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        
        sessionManager.boot(turnstile: self)
    }
}
