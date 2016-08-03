//
//  MemoryRealm.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/27/16.
//
//

/**
 MemoryRealm is a default implementation of the Realm protocol for testing purposes.
 MemoryRealm can store username / password pairs until the application is shut down.
 */
public class MemoryRealm: Realm {
    private var users = [String: String]()
    
    /// Initializer for MemoryRealm
    public init() { }
    
    /**
     Authenticates PasswordCredentials against the Realm.
     */
    public func authenticate(credentials: Credentials) throws -> Account {
        guard let credentials = credentials as? UsernamePassword else {
            throw UnsupportedCredentialsError()
        }
        
        if credentials.password == users[credentials.username] {
            return MemoryAccount(id: credentials.username)
        } else {
            throw IncorrectCredentialsError()
        }
    }
    
    /**
     Registers PasswordCredentials against the MemoryRealm.
     */
    public func register(credentials: Credentials) throws -> Account {
        guard let credentials = credentials as? UsernamePassword else {
            throw UnsupportedCredentialsError()
        }
        guard users[credentials.username] == nil else {
            throw UnsupportedCredentialsError() /// TODO: come up with actual error
        }
        users[credentials.username] = credentials.password
        return MemoryAccount(id: credentials.username)
    }
}

/**
 Account object representing an account in the MemoryRealm.
 */
private struct MemoryAccount: Account {
    private var accountID: String
    
    private init(id: String) {
        accountID = id
    }
}
