//
//  Digits.swift
//  TurnstileWeb
//
//  Created by Kaden Wilkinson on 11/12/16.
//
//

import Foundation
import Turnstile

/**
 Digits allows you to authenticate against Digits for login purposes.
 */
public class Digits: OAuthDelegator, Realm {

    private let authorizationHost = "api.digits.com"

    /**
     Create a Google object. Uses the Client ID and Client Secret from the
     Google Developers Console.
     */
    public override init(consumerKey: String) {
        super.init(consumerKey: consumerKey)
    }

    /**
     Authenticates a Digits access token.
     */
    public func authenticate(credentials: Credentials) throws -> Account {
        switch credentials {
        case let credentials as OAuthEcho:
            return try authenticate(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }
    }
    
    /**
     Authenticates a Digits user using OAuth Echo
     */
    public func authenticate(credentials: OAuthEcho) throws -> DigitsAccount {
        guard credentials.oauthParameters.consumerKey == consumerKey,
            credentials.authServiceProvider.host == authorizationHost else {
                throw IncorrectCredentialsError()
        }

        var request = URLRequest(url: credentials.authServiceProvider)
        request.setValue(credentials.oauthParameters.header, forHTTPHeaderField: "Authorization")

        guard let data = (try? urlSession.executeRequest(request: request))?.0 else {
            throw APIConnectionError()
        }

        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            throw InvalidAPIResponse()
        }

        if let accountID = json["id_str"] as? String {
            return DigitsAccount(uniqueID: accountID)
        }

        throw IncorrectCredentialsError()
    }
}

/**
 A Digits account
 */
public struct DigitsAccount: Account, Credentials {
    public let uniqueID: String
}

/// TODO: refactor facebook and google to using this to an "unknown" OAuth error.
public struct DigitsError: TurnstileError {
    public let description: String

    public init(json: [String: Any]) {
        description = (json["error"] as? [String: Any])?["message"] as? String ?? "Unknown Digits Login Error"
    }
}
