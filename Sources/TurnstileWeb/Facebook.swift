//
//  Facebook.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/8/16.
//
//

import Foundation
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
        let tokenURL = URL(string: "https://graph.facebook.com/v2.3/oauth/access_token")!
        let authorizationURL = URL(string: "https://www.facebook.com/dialog/oauth")!
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
        var urlComponents = URLComponents(string: "https://graph.facebook.com/debug_token")!
        urlComponents.setQueryItems(dict: ["input_token": credentials.token,
                                           "access_token": appAccessToken])
        
        guard let url = urlComponents.url else {
            throw OAuthError() // TODO: replace with a better error
        }
        let request = try! Request(method: .get, url: url)
        request.headers["Accept"] = "application/json"
        
        guard let response = try? Client<TLSClientStream>.respond(to: request) else { throw UnsupportedCredentialsError() }
        guard let responseData = response.json?["data"]?.object else { throw UnsupportedCredentialsError() }

        if let accountID = responseData["user_id"]?.string
            , responseData["app_id"]?.string == clientID && responseData["is_valid"]?.bool == true {
            // TODO: handle errors properly
            return FacebookAccount(accountID: accountID)
        }
        
        throw IncorrectCredentialsError()
    }
    
    private var appAccessToken: String {
        return clientID + "%7C" + clientSecret
    }
}

/**
 A Facebook account
 */
public struct FacebookAccount: Account, Credentials {
    // TODO: represent a lot more from the Facebook account.
    public let accountID: String
}
