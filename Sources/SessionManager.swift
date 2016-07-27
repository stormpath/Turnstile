//
//  SessionManager.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public protocol SessionManager: Bootable {
    func getSession(identifier: String)
    func createSession(subject: Subject) -> String
    func deleteSession(subject: Subject)
}
