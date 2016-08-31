//
//  MemorySessionManager.swift
//  VaporTurnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

import Foundation
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
    
    /// Creates a session for a given Subject object and returns the identifier.
    public func createSession(account: Account) -> String {
        var identifier: String
        
        // Create new random identifiers and find an unused one.
        repeat {
            identifier = Data(bytes: random.random(numBytes: 16)).base64EncodedString()
            identifier = identifier.replacingOccurrences(of: "=", with: "")
            identifier = identifier.replacingOccurrences(of: "+", with: "-")
            identifier = identifier.replacingOccurrences(of: "/", with: "_")
        } while sessions[identifier] != nil
        
        sessions[identifier] = account.uniqueID
        return identifier
    }
    
    /// Deletes the session for a session identifier. 
    public func destroySession(identifier: String) {
        sessions.removeValue(forKey: identifier)
    }
    
    /**
     Creates a Session-backed Account object from the Session store. This only
     contains the SessionID. 
     */
    public func restoreAccount(fromSessionID identifier: String) throws -> Account {
        if let accountID = sessions[identifier] {
            return SessionAccount(uniqueID: accountID)
        } else {
            throw InvalidSessionError()
        }
    }
}
