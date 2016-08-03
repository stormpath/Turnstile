//
//  Bootable.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

/**
 Bootable is a protocol for Turnstile components with an dependency on Turnstile.
 
 Turnstile will pass in a reference to Turnstile, and allow the component to configure itself. 
 
 */

public protocol Bootable {
    
    /// The method called when Turnstile adds the Bootable object to its dependencies.
    func boot(turnstile: Turnstile)
}
