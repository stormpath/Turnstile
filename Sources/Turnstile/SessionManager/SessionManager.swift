//
//  SessionManager.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public protocol SessionManager: Bootable {
    func getSubject(identifier: String) -> Subject?
    func createSession(subject: Subject) -> String
    func deleteSession(identifier: String)
}
