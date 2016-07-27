//
//  Realm.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public protocol Realm {
    func authenticate(credentials: Credentials) throws -> Account
    func register(credentials: Credentials) throws -> Account
    func supports(credentials: Credentials) -> Bool
}

public class DummyRealm: Realm {
    public init() {
        
    }
    
    public func authenticate(credentials: Credentials) throws -> Account {
        guard supports(credentials: credentials) else {
            throw IncorrectCredentialsError()
        }
        let credentials = credentials as! UsernamePasswordCredentials
        
        if credentials.password == "TestTest1" {
            return DummyAccount()
        } else {
            throw IncorrectCredentialsError()
        }
    }
    
    public func register(credentials: Credentials) -> Account {
        return DummyAccount()
    }
    
    public func supports(credentials: Credentials) -> Bool {
        return credentials is UsernamePasswordCredentials
    }
}

struct DummyAccount: Account {
    var accountID: String? = "jaweifja"
}
