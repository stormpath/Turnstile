//
//  SessionManager.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

protocol SessionManager: Bootable {
    subscript(index identifier: String) -> Subject { get set }
}
