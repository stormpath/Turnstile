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

public class Facebook: OAuth2, Realm {
    public init(clientID: String, clientSecret: String) {
        let tokenURL = "https://graph.facebook.com/v2.3/oauth/access_token"
        let authorizationURL = "https://www.facebook.com/dialog/oauth"
        super.init(clientID: clientID, clientSecret: clientSecret, authorizationURL: authorizationURL, tokenURL: tokenURL)
    }
    
    public func authenticate(credentials: Credentials) throws -> Account {
        switch credentials {
        case let credentials as AuthorizationCode:
            return try authenticate(credentials: exchange(authorizationCode: credentials))
        case let credentials as Token:
            return try authenticate(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }
    }
    
    public func authenticate(credentials: Token) throws -> FacebookAccount {
        let url = "https://graph.facebook.com/debug_token?input_token=" + credentials.token + "&access_token=" + appAccessToken
        let request = try! Request(method: .get, uri: url)
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

public struct FacebookAccount: Account, Credentials {
    public let accountID: String
}
