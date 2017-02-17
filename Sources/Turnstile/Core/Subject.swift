//
//  Subject.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

/**
 The user represents the current operating user in Turnstile. This can be anonymous,
 or authenticated against a realm.
 */
public class Subject {
    /// A reference to the Turnstile instance mapped to 
    private let turnstile: Turnstile
    
    /// The authentication details of the current user
    private(set) public var authDetails: AuthenticationDetails?
    
    /// Returns true if the user is authenticated, or false if the user is not.
    public var authenticated: Bool {
        return authDetails != nil
    }
    
    /// Initializes a new user and binds it to the turnstile instance.
    /// If a sessionID is provided, attempts to restore from the Session
    public init(turnstile: Turnstile, sessionID: String? = nil) {
        self.turnstile = turnstile
        
        if let sessionID = sessionID {
            try? restore(fromSessionID: sessionID)
        }
    }
    
    /** 
     Attempts to authenticate the user with the credentials presented. 
     If persist = true, the Subject object is stored in the session manager, which
     sets the user's sessionID
     */
    public func login(credentials: Credentials, persist: Bool = false) throws {
        let account = try turnstile.realm.authenticate(credentials: credentials)
        let sessionID: String? = persist ? turnstile.sessionManager.createSession(account: account) : nil
        let credentialType = type(of: credentials)
        
        authDetails = AuthenticationDetails(account: account, sessionID: sessionID, credentialType: credentialType)
    }
    
    /// Attempts to register the user with the credentials presented.
    public func register(credentials: Credentials) throws {
        _ = try turnstile.realm.register(credentials: credentials)
    }
    
    /// Logs out the user, and deletes the current session.
    public func logout() {
        if let sessionIdentifier = authDetails?.sessionID {
            turnstile.sessionManager.destroySession(identifier: sessionIdentifier)
        }
        authDetails = nil
    }
    
    private func restore(fromSessionID sessionID: String) throws {
        let account = try turnstile.sessionManager.restoreAccount(fromSessionID: sessionID)
        
        authDetails = AuthenticationDetails(account: account, sessionID: sessionID, credentialType: Session.self)
    }
}

/// A struct representing the authentication details of a logged in user.
public struct AuthenticationDetails {
    /// The user's Account object as represented by the Realm.
    public let account: Account
    
    /**
     The session ID created by the session manager. You can use this to retrieve
     the user from the session store.
     */
    public let sessionID: String?
    
    /**
     The credential type the user authenticated with. This is a reference to the
     Credentials instance metatype. You can check its equality (as of Swift 3 7/25)
     by credentialType = Credentials.self, or credentialType = credentials.dynamicType.
     */
    public let credentialType: Credentials.Type
}
