//
//  SessionManager.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

/**
 SessionManager is a Turnstile component that manages sessions for your authentication
 system. Feel free to come up with your own implementation that connects to an
 external database, Redis, or other persistient cluster.
 */
public protocol SessionManager {
    /**
     Gets the account ID for the current session identifier.
     */
    func restoreAccount(fromSessionID identifier: String) throws -> Account
    
    /// Creates a session for a given Account object and returns the identifier.
    func createSession(account: Account) -> String
    
    /// Destroys the session for a session identifier.
    func destroySession(identifier: String)
}

/**
 An invalid Session error is thrown when a session ID presented could not be found.
 */
public struct InvalidSessionError: TurnstileError {
    public let description = "Invalid session ID"
    
    public init() {}
}

/**
 Represents a generic account that is stored in a session, using a SessionID.
 Accounts in Sessions usually will not be the full account, as that requires
 a database call.
 */
public struct SessionAccount: Account {
    public let uniqueID: String
    
    public init(uniqueID: String) {
        self.uniqueID = uniqueID
    }
}
