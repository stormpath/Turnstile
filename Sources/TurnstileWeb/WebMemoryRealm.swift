//
//  WebMemoryRealm.swift
//  Turnstile
//
//  Created by Edward Jiang on 9/14/16.
//
//

import Turnstile
import TurnstileCrypto

/**
 WebMemoryRealm is a default implementation of the Realm protocol for testing purposes, with support for TurnstileWeb.
 WebMemoryRealm can store username / password pairs, Facebook, and Google credentials
 until the application is shut down.
 */
public class WebMemoryRealm: Realm {
    private var accounts = [MemoryAccount]()
    private var random: Random = URandom()
    
    /// Initializer for MemoryRealm
    public init() { }
    
    /**
     Authenticates PasswordCredentials against the Realm.
     */
    public func authenticate(credentials: Credentials) throws -> Account {
        switch credentials {
        case let credentials as UsernamePassword:
            return try authenticate(credentials: credentials)
        case let credentials as APIKey:
            return try authenticate(credentials: credentials)
        case let credentials as FacebookAccount:
            return try authenticate(credentials: credentials)
        case let credentials as GoogleAccount:
            return try authenticate(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }
    }
    
    private func authenticate(credentials: UsernamePassword) throws -> Account {
        if let account = accounts.filter({$0.username == credentials.username && $0.password == credentials.password}).first {
            return account
        } else {
            throw IncorrectCredentialsError()
        }
    }
    
    private func authenticate(credentials: APIKey) throws -> Account {
        if let account = accounts.filter({$0.uniqueID == credentials.id && $0.apiKeySecret == credentials.secret}).first {
            return account
        } else {
            throw IncorrectCredentialsError()
        }
    }
    
    private func authenticate(credentials: FacebookAccount) throws -> Account {
        if let account = accounts.filter({$0.facebookID == credentials.uniqueID}).first {
            return account
        } else {
            return try register(credentials: credentials)
        }
    }
    
    private func authenticate(credentials: GoogleAccount) throws -> Account {
        if let account = accounts.filter({$0.googleID == credentials.uniqueID}).first {
            return account
        } else {
            return try register(credentials: credentials)
        }
    }
    
    /**
     Registers PasswordCredentials against the MemoryRealm.
     */
    public func register(credentials: Credentials) throws -> Account {
        var newAccount = MemoryAccount(id: String(random.secureToken))
        
        switch credentials {
        case let credentials as UsernamePassword:
            guard accounts.filter({$0.username == credentials.username}).first == nil else {
                throw AccountTakenError()
            }
            newAccount.username = credentials.username
            newAccount.password = credentials.password
        case let credentials as FacebookAccount:
            guard accounts.filter({$0.facebookID == credentials.uniqueID}).first == nil else {
                throw AccountTakenError()
            }
            newAccount.facebookID = credentials.uniqueID
        case let credentials as GoogleAccount:
            guard accounts.filter({$0.googleID == credentials.uniqueID}).first == nil else {
                throw AccountTakenError()
            }
            newAccount.googleID = credentials.uniqueID
        default:
            throw UnsupportedCredentialsError()
        }
        accounts.append(newAccount)
        return newAccount
    }
}

/**
 Account object representing an account in the MemoryRealm.
 */
public struct MemoryAccount: Account {
    public var uniqueID: String
    public var username: String?
    public var password: String?
    public var apiKeySecret: String = URandom().secureToken
    
    public var facebookID: String?
    public var googleID: String?
    
    init(id: String) {
        uniqueID = id
    }
}
