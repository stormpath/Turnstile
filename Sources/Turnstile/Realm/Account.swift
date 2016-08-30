//
//  Account.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

/// A protocol representing an actual user account returned from a Realm.
public protocol Account {
    /**
     The account ID. Since a SessionManager can only be paired with one Realm,
     the uniqueID only needs to be unique within the Realm that generated the Account.
     */
    var uniqueID: String { get }
}
