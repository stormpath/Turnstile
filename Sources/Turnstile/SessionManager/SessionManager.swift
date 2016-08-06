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
     Gets the user for the current session identifier.
     
     TODO: change this to a throwing interface
     */
    func getUser(identifier: String) -> User?
    
    /// Creates a session for a given User object and returns the identifier.
    func createSession(user: User) -> String
    
    /// Destroys the session for a session identifier.
    func destroySession(identifier: String)
}
