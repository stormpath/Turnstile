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
    
    static var allKeys: [OAuthKey] = [.signatureMethod,
                   .token,
                   .consumerKey,
                   .timestamp,
                   .nonce,
                   .version,
                   .signature]
}

/**
 Represents a set of OAuth Authentication Parameters, and helps you parse it out. 
 This class cannot generate an authentication header nor sign the OAuth parameters.
 
 See https://tools.ietf.org/html/rfc5849#section-3.5
 */
public class OAuthParameters {
    /// Signature method of the OAuth header
    public var signatureMethod: String {
        return parameterDictionary[OAuthKey.signatureMethod.rawValue]!
    }
    
    /// OAuth Token
    public var token: String {
        return parameterDictionary[OAuthKey.token.rawValue]!
    }
    
    /// Consumer Key
    public var consumerKey: String {
        return parameterDictionary[OAuthKey.consumerKey.rawValue]!
    }
    
    /// Timestamp for the request
    public var timestamp: String {
        return parameterDictionary[OAuthKey.timestamp.rawValue]!
    }
    
    /// One time use nonce
    public var nonce: String {
        return parameterDictionary[OAuthKey.nonce.rawValue]!
    }
    
    /// OAuth version number
    public var version: String {
        return parameterDictionary[OAuthKey.version.rawValue]!
    }
    
    /// OAuth signature
    public var signature: String {
        return parameterDictionary[OAuthKey.signature.rawValue]!
    }
    
    /// OAuth Value for Header
    public var header: String {
        let partialHeader = parameterDictionary.sorted { $0.0.key < $0.1.key }
        .map { (keyValuePair) -> String in
            let values = keyValuePair.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            return "\(keyValuePair.key)=\"\(values)\""
        }
        .joined(separator: ", ")
        return "OAuth \(partialHeader)"
    }
    
    /// Storage for all OAuth parameters
    private let parameterDictionary: [String: String]
    
    /// Parses a string (presumably from the authorization header) for its OAuth parameters.
    public init?(header: String) {
        guard header.hasPrefix("OAuth ") else {
            return nil
        }
        
        // Parse out OAuth parameters
        var header = header.substring(from: header.index(header.startIndex, offsetBy: 6))
        
        header = header.replacingOccurrences(of: " ", with: "")
        header = header.replacingOccurrences(of: "\"", with: "")

        self.parameterDictionary =  header.components(separatedBy: ",").map { keyValuePair in
            keyValuePair.components(separatedBy: "=")
        }
        .reduce([String: String]()) { (keyValuePairs, keyValuePair) -> [String: String] in
            var keyValuePairs = keyValuePairs
            keyValuePairs[keyValuePair[0]] = keyValuePair[1].removingPercentEncoding
            return keyValuePairs
        }
        
        // Check all required values are there
        for key in OAuthKey.allKeys {
            if self.parameterDictionary[key.rawValue] == nil {
                return nil
            }
        }
    }
}
