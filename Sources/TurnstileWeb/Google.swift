//
//  Google.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/10/16.
//
//

import Foundation
import Turnstile

/**
 Google allows you to authenticate against Google for login purposes.
 */
public class Google: OpenIDConnect<GoogleAccount> {
    
    /**
     Create a Google object. Uses the Client ID and Client Secret from the
     Google Developers Console.
     */
    public init(clientID: String, clientSecret: String) {
        let tokenURL = URL(string: "https://www.googleapis.com/oauth2/v4/token")!
        let authorizationURL = URL(string: "https://accounts.google.com/o/oauth2/auth")!
        let userDataURL = URL(string: "https://www.googleapis.com/oauth2/v3/tokeninfo")!
        super.init(clientID: clientID, clientSecret: clientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL, userDataURL: userDataURL)
    }
    
    /**
     Turns the credentials passed through the OAuth2 exchange into a Google
     user data request.
     */
    public override func authenticatedRequest(credentials: AccessToken) -> URLRequest {
        let urlString = "\(userDataURL.absoluteString)?access_token=\(credentials.string)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    /**
     Creates a Google account from the JSON passed-in.
     */
    public override func makeAccount(json: [String : Any]) throws -> GoogleAccount {
        guard let accountID = json["sub"] as? String,
            (json["aud"] as? String)?.components(separatedBy: "-").first == clientID.components(separatedBy: "-").first else {
                throw IncorrectCredentialsError()
        }
        return GoogleAccount(uniqueID: accountID)
    }
    
    public override func getLoginLink(redirectURL: String, state: String, scopes: [String] = ["profile"]) -> URL {
        return super.getLoginLink(redirectURL: redirectURL, state: state, scopes: scopes)
    }
}

/**
 A Google account with a unique ID
 */
public struct GoogleAccount: Account, Credentials {
    public let uniqueID: String
}

/// TODO: refactor facebook and google to using this to an "unknown" OAuth error.
public struct GoogleError: TurnstileError {
    public let description: String
    
    public init(json: [String: Any]) {
        description = (json["error"] as? [String: Any])?["message"] as? String ?? "Unknown Google Login Error"
    }
}
