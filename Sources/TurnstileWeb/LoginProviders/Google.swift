//
//  Google.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/10/16.
//
//

import Foundation
import Turnstile

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
        let tokenURL = URL(string: "https://www.googleapis.com/oauth2/v4/token")!
        let authorizationURL = URL(string: "https://accounts.google.com/o/oauth2/auth")!
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
        let url = URL(string: "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=" + credentials.string)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let data = (try? urlSession.executeRequest(request: request))?.0 else {
            throw APIConnectionError()
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            throw InvalidAPIResponse()
        }
        
        if let accountID = json["sub"] as? String
            , (json["aud"] as? String)?.components(separatedBy: "-").first == clientID.components(separatedBy: "-").first {
            var account = GoogleAccount(uniqueID: accountID, accessToken: credentials)
            account.email = json["email"] as? String
            return GoogleAccount(uniqueID: accountID, accessToken: credentials)
        }
        
        throw IncorrectCredentialsError()
    }
    
    public override func getLoginLink(redirectURL: String, state: String, scopes: [String] = ["profile"]) -> URL {
        return super.getLoginLink(redirectURL: redirectURL, state: state, scopes: scopes)
    }
}

/**
 A Google account
 */
public struct GoogleAccount: Account, Credentials {
    public let uniqueID: String
    public let accessToken: AccessToken
    public var email: String? = nil
    
    init(uniqueID: String, accessToken: AccessToken) {
        self.uniqueID = uniqueID
        self.accessToken = accessToken
    }
}

/// TODO: refactor facebook and google to using this to an "unknown" OAuth error.
public struct GoogleError: TurnstileError {
    public let description: String
    
    public init(json: [String: Any]) {
        description = (json["error"] as? [String: Any])?["message"] as? String ?? "Unknown Google Login Error"
    }
}
