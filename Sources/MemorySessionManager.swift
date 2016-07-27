//
//  MemorySessionManager.swift
//  VaporTurnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

import Foundation

class VaporSessionManager: SessionManager {
    var sessions = [String: Subject]()
    weak var turnstile: Turnstile!
    
    func boot(turnstile: Turnstile) {
        self.turnstile = turnstile
    }
    
    
    func getSubject(identifier: String) -> Subject? {
        return sessions[identifier]
    }
    
    func createSession(subject: Subject) -> String {
        // Temp implementation; actually fix later
        let identifier = String(arc4random_uniform(1000000))
        subject.sessionIdentifier = identifier
        sessions[identifier] = subject
        return identifier
    }
    
    func deleteSession(identifier: String) {
        sessions.removeValue(forKey: identifier)
    }
}
