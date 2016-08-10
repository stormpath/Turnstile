//
//  Facebook.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/8/16.
//
//

import Turnstile
import HTTP
import JSON

/**
 Facebook allows you to authenticate against Facebook for login purposes.
 */
public class Facebook: OAuth2, Realm {
    /**
     Create a Facebook object. Uses the Client ID and Client Secret from the
     Facebook Developers Console.
     */
    public init(clientID: String, clientSecret: String) {
        let tokenURL = "https://graph.facebook.com/v2.3/oauth/access_token"
        let authorizationURL = "https://www.facebook.com/dialog/oauth"
        super.init(clientID: clientID, clientSecret: clientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL)
    }
    
    /**
     Authenticates a Facebook access token.
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
     Authenticates a Facebook access token.
     */
    public func authenticate(credentials: Token) throws -> FacebookAccount {
        let url = "https://graph.facebook.com/debug_token?input_token=" + credentials.token + "&access_token=" + appAccessToken
        let request = try! Request(method: .get, uri: url)
        request.headers["Accept"] = "application/json"
        
        guard let response = try? Client<TLSClientStream>.respond(to: request) else { throw APIConnectionError() }
        guard let json = response.json else { throw InvalidAPIResponse() }
        
        guard let responseData = json["data"]?.object else {
            throw FacebookError(json: json)
        }

        if let accountID = responseData["user_id"]?.string
            , responseData["app_id"]?.string == clientID && responseData["is_valid"]?.bool == true {
            return FacebookAccount(accountID: accountID)
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
    public let accountID: String
}

/**
 An error resulting from Facebook Login
 */
public struct FacebookError: TurnstileError {
    /// Description of the error
    public let description: String
    
    /// Initializer
    public init(json: JSON) {
        description = json["error"]?["message"]?.string ?? "Unknown Facebook Login Error"
    }
}
