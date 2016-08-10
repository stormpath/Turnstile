//
//  Google.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/10/16.
//
//

import Foundation
import Turnstile
import HTTP
import JSON

/**
 Google allows you to authenticate against Google for login purposes.
 */
public class Google: OAuth2, Realm {
    /**
     Create a Google object. Uses the Client ID and Client Secret from the
     Google Developers Console.
     */
    public init(clientID: String, clientSecret: String) {
        let tokenURL = "https://www.googleapis.com/oauth2/v4/token"
        let authorizationURL = "https://accounts.google.com/o/oauth2/auth"
        super.init(clientID: clientID, clientSecret: clientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL)
    }
    
    /**
     Authenticates a Google access token.
     */
    public func authenticate(credentials: Credentials) throws -> Account {
        switch credentials {
        case let credentials as Token:
            return try authenticate(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }
    }
    
    /**
     Authenticates a Google access token.
     */
    public func authenticate(credentials: Token) throws -> GoogleAccount {
        let url = "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=" + credentials.token
        let request = try! Request(method: .get, uri: url)
        request.headers["Accept"] = "application/json"
        
        guard let response = try? Client<TLSClientStream>.respond(to: request) else { throw APIConnectionError() }
        guard let json = response.json else { throw InvalidAPIResponse() }
        
        guard let responseData = json["data"]?.object else {
            throw GoogleError(json: json)
        }
        
        if let accountID = responseData["user_id"]?.string
            , responseData["audience"]?.string?.components(separatedBy: "-")[0] == clientID.components(separatedBy: "-")[0] {
            return GoogleAccount(accountID: accountID)
        }
        
        throw IncorrectCredentialsError()
    }
}

/**
 A Google account
 */
public struct GoogleAccount: Account, Credentials {
    public let accountID: String
}

/// TODO: refactor facebook and google to using this to an "unknown" OAuth error.
public struct GoogleError: TurnstileError {
    public let description: String
    
    public init(json: JSON) {
        description = json["error"]?["message"]?.string ?? "Unknown Google Login Error"
    }
}
