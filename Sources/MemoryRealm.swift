//
//  MemoryRealm.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/27/16.
//
//

public class MemoryRealm: Realm {
    var users = [String: String]() // Keys of users, values of passwords
    
    public init() { }
    
    public func canAuthenticate(credentialType: Credentials.Type) -> Bool {
        return credentialType is PasswordCredentials.Type
    }
    
    public func authenticate(credentials: Credentials) throws -> Account {
        guard let credentials = credentials as? PasswordCredentials else {
            throw IncorrectCredentialsError()
        }
        
        guard let password = users[credentials.username] else {
            throw IncorrectCredentialsError()
        }
        
        if credentials.password == password {
            return MemoryAccount(id: credentials.username)
        } else {
            throw IncorrectCredentialsError()
        }
    }
    
    public func canRegister(credentialType: Credentials.Type) -> Bool {
        return credentialType is PasswordCredentials.Type
    }
    
    public func register(credentials: Credentials) throws -> Account {
        guard let credentials = credentials as? PasswordCredentials else {
            throw IncorrectCredentialsError()
        }
        guard users[credentials.username] == nil else {
            throw GenericError()
        }
        users[credentials.username] = credentials.password
        return MemoryAccount(id: credentials.username)
    }
}

struct MemoryAccount: Account {
    var accountID: String?
    
    init(id: String) {
        accountID = id
    }
}
