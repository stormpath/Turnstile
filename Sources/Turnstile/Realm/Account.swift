//
//  Account.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

/// A protocol representing an actual user account returned from a Realm.
public protocol Account {
    /// The account ID
    var accountID: String { get }
    var realm: Realm.Type { get } 
}
