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
    private var sessions = [String: String]()
    private let random: Random = URandom()
    
    /// Initializes the Session Manager. No config needed!
    public init() {}
    
    /// Gets the user for the current session identifier.
    public func getAccountID(fromSessionID identifier: String) throws -> String {
        if let accountID = sessions[identifier] {
            return accountID
        } else {
            throw InvalidSessionError()
        }
    }
    
    /// Creates a session for a given Subject object and returns the identifier.
    public func createSession(subject: Subject) -> String {
        // TODO: Use a 128 bit session ID (base64/62 encoded) when Foundation works on Linux.
        // Not a priority right now since MemorySessionManager is not for production use.
        var identifier: String
        
        // Create new random identifiers and find an unused one.
        repeat {
            identifier = String(random.int64)
        } while sessions[identifier] != nil
        
        sessions[identifier] = subject.authDetails?.account.accountID
        return identifier
    }
    
    /// Deletes the session for a session identifier. 
    public func destroySession(identifier: String) {
        sessions.removeValue(forKey: identifier)
    }
}
