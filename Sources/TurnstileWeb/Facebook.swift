//
//  Facebook.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/8/16.
//
//

import Foundation
import Turnstile

/**
 Facebook allows you to authenticate against Facebook for login purposes.
 */
public class Facebook: OAuth2, Realm {
    /**
     Create a Facebook object. Uses the Client ID and Client Secret from the
     Facebook Developers Console.
     */
    public init(clientID: String, clientSecret: String) {
        let tokenURL = URL(string: "https://graph.facebook.com/v2.3/oauth/access_token")!
        let authorizationURL = URL(string: "https://www.facebook.com/dialog/oauth")!
        super.init(clientID: clientID, clientSecret: clientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL)
    }
    
    /**
     Authenticates a Facebook access token.
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
     Authenticates a Facebook access token.
     */
    public func authenticate(credentials: AccessToken) throws -> FacebookAccount {
        var urlComponents = URLComponents(string: "https://graph.facebook.com/debug_token")!
        urlComponents.setQueryItems(dict: ["input_token": credentials.string,
                                           "access_token": appAccessToken])
        
        guard let url = urlComponents.url else {
            throw FacebookError(json: [String: Any]())
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let data = (try? urlSession.executeRequest(request: request))?.0 else {
            throw APIConnectionError()
        }
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            throw InvalidAPIResponse()
        }
        
        guard let responseData = json["data"] as? [String: Any] else {
            throw FacebookError(json: json)
        }

        if let accountID = responseData["user_id"] as? String
            , responseData["app_id"] as? String == clientID && responseData["is_valid"] as? Bool == true {
            return FacebookAccount(uniqueID: accountID)
        }
        
        throw IncorrectCredentialsError()
    }
    
    private var appAccessToken: String {
        return clientID + "%7C" + clientSecret
    }
    
    // TODO: add facebook specific auth types (like reauthenticate, rerequest)
}

/**
 A Facebook account
 */
public struct FacebookAccount: Account, Credentials {
    // TODO: represent a lot more from the Facebook account.
    public let uniqueID: String
}

/**
 An error resulting from Facebook Login
 */
public struct FacebookError: TurnstileError {
    /// Description of the error
    public let description: String
    
    /// Initializer
    public init(json: [String: Any]) {
        description = (json["error"] as? [String: Any])?["message"] as? String ?? "Unknown Facebook Login Error"
    }
}
