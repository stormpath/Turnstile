//
//  OAuth2.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/7/16.
//
//

import Turnstile
import Foundation
import HTTP
import JSON

/**
 OAuth 2 represents the base API Client for an OAuth 2 server that implements the
 authorization code grant type. This is the typical redirect based login flow
 you see on .
 
 Since OAuth doesn't define token validation, implementing it is up to a subclass.
 */
public class OAuth2 {
    /// The Client ID for the OAuth 2 Server
    public let clientID: String
    
    /// The Client Secret for the OAuth 2 Server
    public let clientSecret: String
    
    /// The Authorization Endpoint of the OAuth 2 Server
    public let authorizationURL: String
    
    /// The Token Endpoint of the OAuth 2 Server
    public let tokenURL: String
    
    let HTTPClient = Client<TLSClientStream>.self
    
    
    /// Creates the OAuth 2 client
    public init(clientID: String, clientSecret: String, authorizationURL: String, tokenURL: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authorizationURL = authorizationURL
        self.tokenURL = tokenURL
    }
    
    
    /// Gets the login link for the OAuth 2 server. Redirect the end user to this URL
    ///
    /// - parameter redirectURL: The URL for the server to redirect the user back to after login. 
    ///     You will need to configure this in the admin console for the OAuth provider's site.
    /// - parameter state:       A randomly generated string to prevent CSRF attacks. 
    ///     Verify this when validating the Authorization Code
    /// - parameter scopes:      A list of OAuth scopes you'd like the user to grant.
    public func getLoginLink(redirectURL: String, state: String, scopes: [String] = []) -> String {
        // TODO: serialize these better
        var loginLink = authorizationURL + "?"
        loginLink += "response_type=code"
        loginLink += "&client_id=" + clientID
        loginLink += "&redirect_uri=" + redirectURL
        loginLink += "&state=" + state
        loginLink += "&scopes=" + scopes.joined(separator: "%20")
        
        return loginLink
    }
    
    
    /// Exchanges an authorization code for an access token
    /// - throws: InvalidAuthorizationCodeError() if the Authorization Code could not be validated
    /// - throws: APIConnectionError() if we cannot connect to the OAuth server
    /// - throws: InvalidAPIResponse() if the server does not respond in a way we expect
    public func exchange(authorizationCode: AuthorizationCode) throws -> Token {
        // TODO: serialize these better
        let url = tokenURL + "?client_id=\(clientID)&redirect_uri=\(authorizationCode.redirectURL)&client_secret=\(clientSecret)&code=\(authorizationCode.code)"
        let request = try! Request(method: .get, uri: url)
        
        request.headers["Accept"] = "application/json"
        
        guard let response = try? HTTPClient.respond(to: request) else {
            throw APIConnectionError()
        }
        guard let json = response.json else {
            throw InvalidAPIResponse()
        }
        guard let accessToken = json["access_token"]?.string else {
            if let error = OAuth2Error(json: json) {
                throw error
            } else {
                throw InvalidAPIResponse()
            }
        }
        return Token(token: accessToken)
    }
    
    /// Convenience function for grabbing the authorization code from the query string
    /// - throws: InvalidAuthorizationCodeError() if the Authorization Code could not be validated
    /// - throws: APIConnectionError() if we cannot connect to the OAuth server
    /// - throws: InvalidAPIResponse() if the server does not respond in a way we expect
    public func exchange(codeFromQueryString queryString: String) throws -> Token {
        preconditionFailure("Not implemented") // TODO
    }
}
