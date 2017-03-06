//
//  Twitter.swift
//  TurnstileWeb
//
//  Created by Kaden Wilkinson on 11/30/16.
//
//

import Foundation
import Turnstile

/**
 Twitter allows you to authenticate against Twitter for login purposes.
 */
public class Twitter: OAuthDelegator, Realm {

    private let authorizationHost = "api.twitter.com"

    /**
     Create a Twitter object. Uses the Consumer Key from the fabric.io dashboard
     */
    public override init(consumerKey: String) {
        super.init(consumerKey: consumerKey)
    }

    /**
     Authenticates Twitter credentials.
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
     Authenticates a Twitter user using OAuth Echo
     */
    public func authenticate(credentials: OAuthEcho) throws -> TwitterAccount {
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
            return TwitterAccount(uniqueID: accountID)
        }

        throw IncorrectCredentialsError()
    }
}

/**
 A Digits account
 */
public struct TwitterAccount: Account, Credentials {
    public let uniqueID: String
}
