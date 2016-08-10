//
//  MemorySessionManager.swift
//  VaporTurnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

import TurnstileCrypto

/**
 MemorySessionManager manages sessions in-memory and is great for development
 purposes.
 */
public class MemorySessionManager: SessionManager {
    /// Dictionary of sessions
    private var sessions = [String: User]()
    private let random: Random = URandom()
    
    /// Initializes the Session Manager. No config needed!
    public init() {}
    
    /// Gets the user for the current session identifier.
    public func getUser(identifier: String) throws -> User {
        if let user = sessions[identifier] {
            return user
        } else {
            throw InvalidSessionError()
        }
    }
    
    /// Creates a session for a given User object and returns the identifier.
    public func createSession(user: User) -> String {
        // TODO: Use a 128 bit session ID (base64/62 encoded)
        var identifier: String
        
        // Create new random identifiers and find an unused one.
        repeat {
            identifier = String(random.int64)
        } while sessions[identifier] != nil
        
        sessions[identifier] = user
        return identifier
    }
    
    /// Deletes the session for a session identifier. 
    public func destroySession(identifier: String) {
        sessions.removeValue(forKey: identifier)
    }
}
