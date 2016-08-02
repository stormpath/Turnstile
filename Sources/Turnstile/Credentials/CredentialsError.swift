//
//  CredentialsError.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/27/16.
//
//

public protocol CredentialsError: ErrorProtocol, CustomStringConvertible {
    // Stub protocol
}

public struct GenericError: CredentialsError {
    public init() {}
    
    public var description: String {
        return "We shouldn't actually use this error in the future"
    }
}
public struct IncorrectCredentialsError: CredentialsError {
    public init() {}
    
    public var description: String {
        return "Invalid Credentials"
    }
}

public struct UnsupportedCredentialsError: CredentialsError {
    public init() {}
    
    public var description: String {
        return "Unsupported Credentials"
    }
}
