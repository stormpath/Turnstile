//
//  MemorySessionManager.swift
//  VaporTurnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

import Foundation

public class MemorySessionManager: SessionManager {
    var sessions = [String: User]()
    weak var turnstile: Turnstile!
    
    public init() {}
    
    public func boot(turnstile: Turnstile) {
        self.turnstile = turnstile
    }
    
    
    public func getUser(identifier: String) -> User? {
        return sessions[identifier]
    }
    
    public func createSession(user: User) -> String {
        // Temp implementation; actually fix later
        let identifier = String(arc4random_uniform(1000000))
        sessions[identifier] = user
        return identifier
    }
    
    public func deleteSession(identifier: String) {
        sessions.removeValue(forKey: identifier)
    }
}
