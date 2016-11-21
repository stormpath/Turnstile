//
//  OAuthToken.swift
//  TurnstileWeb
//
//  Created by Kaden Wilkinson on 11/12/16.
//
//

import Foundation
import Turnstile

private enum OAuthKey: String {
    case signatureMethod = "oauth_signature_method"
    case token = "oauth_token"
    case consumerKey = "oauth_consumer_key"
    case timestamp = "oauth_timestamp"
    case nonce = "oauth_nonce"
    case version = "oauth_version"
    case signature = "oauth_signature"
}


/**
 Represents a set of OAuth Authentication Parameters, and helps you parse it out. 
 This class cannot generate an authentication header nor sign the OAuth parameters.
 
 See https://tools.ietf.org/html/rfc5849#section-3.5
 */
public class OAuthParameters {
    /// Signature method of the OAuth header
    public let signatureMethod: String
    
    /// OAuth Token
    public let token: String
    
    /// Consumer Key
    public let consumerKey: String
    
    /// Timestamp for the request
    public let timestamp: String
    
    /// One time use nonce
    public let nonce: String
    
    /// OAuth version number
    public let version: String
    
    /// OAuth signature
    public let signature: String
    
    private init(
        signatureMethod: String = "HMAC-SHA1",
        token: String,
        consumerKey: String,
        timestamp: String,
        nonce: String,
        version: String = "1.0",
        signature: String
    ) {
        self.signatureMethod = signatureMethod
        self.token = token
        self.consumerKey = consumerKey
        self.timestamp = timestamp
        self.nonce = nonce
        self.version = version
        self.signature = signature
    }
    
    /// Parses a string (presumably from the authorization header) for its OAuth parameters.
    public convenience init?(header: String) {
        var signatureMethod: String?
        var token: String?
        var consumerKey: String?
        var timestamp: String?
        var nonce: String?
        var version: String?
        var signature: String?

        var header = header.replacingOccurrences(of: "OAuth ", with: "")
        header = header.replacingOccurrences(of: " ", with: "")

        var components = header.components(separatedBy: ",")
        let escapedQuotes = "\""
        components = components.map { $0.replacingOccurrences(of: escapedQuotes, with: "", options: .literal) }

        let componentLst = components.map { $0.components(separatedBy: "=") }

        componentLst.forEach { component in
            if let key = OAuthKey(rawValue: component[0]) {
                let value = component[1]
                switch key {
                case .signatureMethod:
                    signatureMethod = value
                case .token:
                    token = value
                case .consumerKey:
                    consumerKey = value
                case .timestamp:
                    timestamp = value
                case .nonce:
                    nonce = value
                case .version:
                    version = value
                case .signature:
                    signature = value
                }
            }
        }

        guard
            signatureMethod != nil,
            token != nil,
            consumerKey != nil,
            timestamp != nil,
            nonce != nil,
            version != nil,
            signature != nil else {
            return nil
        }

        self.init(signatureMethod: signatureMethod!,
                  token: token!,
                  consumerKey: consumerKey!,
                  timestamp: timestamp!,
                  nonce: nonce!,
                  version: version!,
                  signature: signature!)
    }
}
