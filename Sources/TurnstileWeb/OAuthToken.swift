//
//  OAuthToken.swift
//  TurnstileWeb
//
//  Created by Kaden Wilkinson on 11/12/16.
//
//

import Foundation
import Turnstile


enum OAuth1Key: String {
    case signatureMethod = "oauth_signature_method"
    case token = "oauth_token"
    case consumerKey = "oauth_consumer_key"
    case timestamp = "oauth_timestamp"
    case nonce = "oauth_nonce"
    case version = "oauth_version"
    case signature = "oauth_signature"
}


/**
 Represents an OAuth Token
 */
public class OAuthToken {
    public let signatureMethod: String
    public let token: String
    public let consumerKey: String
    public let timestamp: String
    public let nonce: String
    public let version: String
    public let signature: String
    public var header: String {
        get {
            return "OAuth " +
            "oauth_signature=\"\(signatureMethod)\"," +
            "oauth_nonce=\"\(nonce)\"," +
            "oauth_timestamp=\"\(timestamp)\"," +
            "oauth_consumer_key=\"\(consumerKey)\"," +
            "oauth_token=\"\(token)\"," +
            "oauth_version=\"\(version)\"," +
            "oauth_signature_method=\"\(signatureMethod)\""
        }
    }

    public init(
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
            if let key = OAuth1Key(rawValue: component[0]) {
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
