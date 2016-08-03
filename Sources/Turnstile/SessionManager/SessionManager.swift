//
//  SessionManager.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public protocol SessionManager: Bootable {
    func getUser(identifier: String) -> User?
    func createSession(user: User) -> String
    func deleteSession(identifier: String)
}
