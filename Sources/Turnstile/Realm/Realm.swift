//
//  Realm.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

/**
 A realm connects Turnstile to your data store, and allows Turnstile to authenticate
 and register accounts.
 
 To use Turnstile, you will most likely be implementing your own realm. Each realm
 should represent one account store, so if you have multiple account stores, you
 should build one realm to implement the account store logic, and link to realms
 underneath that do the actual authentication.
 
 Realms should throw UnsupportedCredentialsErrors on invalid credential types,
 or InvalidCredentialsErrors on invalid credentials.
 */
public protocol Realm {
    /**
     Check if a set of credentials is valid, and if so, returns an account.
     */
    func authenticate(credentials: Credentials) throws -> Account
    
    /**
     Register a set of credentials with the realm. 
     
     If you're implementing Turnstile in your application, you may choose to not
     implement the registration functionality, as it's not meant to be a full
     user managment. This is only useful for applications with simple
     username/password stores, or Facebook accounts, for instance.
     */
    func register(credentials: Credentials) throws -> Account
}

public extension Realm {
    public func register(credentials: Credentials) throws -> Account {
        throw UnsupportedCredentialsError()
    }
}
