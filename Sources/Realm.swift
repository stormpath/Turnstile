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
