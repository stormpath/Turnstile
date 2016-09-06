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

// TODO: split out some of this logic into an OpenID Connect framework. 

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
        case let credentials as AccessToken:
            return try authenticate(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }
    }
    
    /**
     Authenticates a Google access token.
     */
    public func authenticate(credentials: AccessToken) throws -> GoogleAccount {
        let url = "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=" + credentials.string
        let request = try! Request(method: .get, uri: url)
        request.headers["Accept"] = "application/json"
        
        guard let response = try? HTTPClient.respond(to: request) else { throw APIConnectionError() }
        guard let json = response.json else { throw InvalidAPIResponse() }
        
        if let accountID = json["sub"]?.string
            , json["aud"]?.string?.components(separatedBy: "-").first == clientID.components(separatedBy: "-").first {
            return GoogleAccount(uniqueID: accountID)
        }
        
        throw IncorrectCredentialsError()
    }
    
    public override func getLoginLink(redirectURL: String, state: String, scopes: [String] = ["profile"]) -> String {
        return super.getLoginLink(redirectURL: redirectURL, state: state, scopes: scopes)
    }
}

/**
 A Google account
 */
public struct GoogleAccount: Account, Credentials {
    public let uniqueID: String
}

/// TODO: refactor facebook and google to using this to an "unknown" OAuth error.
public struct GoogleError: TurnstileError {
    public let description: String
    
    public init(json: JSON) {
        description = json["error"]?["message"]?.string ?? "Unknown Google Login Error"
    }
}
