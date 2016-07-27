//
//  SessionManager.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

public protocol SessionManager: Bootable {
    subscript(identifier: String) -> Subject { get set }
}
