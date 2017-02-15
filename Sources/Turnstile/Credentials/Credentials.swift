//
//  Credentials.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/27/16.
//
//

/**
 An empty protocol representing a credentials object. Since credentials can be
 very different, try to use Turnstile provided credentials when they fit your needs,
 or open a GitHub issue or Pull Request to represent another type of credentials. 
 */
public protocol Credentials { }

public struct Session: Credentials {}
