//
//  Realm.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public protocol Realm {
    func canAuthenticate(credentialType: Credentials.Type) -> Bool
    func authenticate(credentials: Credentials) throws -> Account
    func canRegister(credentialType: Credentials.Type) -> Bool
    func register(credentials: Credentials) throws -> Account
}
