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
    public let authorizationURL: URL
    
    /// The Token Endpoint of the OAuth 2 Server
    public let tokenURL: URL
    
    let HTTPClient = Client<TLSClientStream>.self
    
    
    /// Creates the OAuth 2 client
    public init(clientID: String, clientSecret: String, authorizationURL: URL, tokenURL: URL) {
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
    public func getLoginLink(redirectURL: String, state: String, scopes: [String] = []) throws -> URL {
        let queryItems = ["response_type": "code",
                          "client_id": clientID,
                          "redirect_uri": redirectURL,
                          "state": state,
                          "scopes": scopes.joined(separator: " ")]
        var urlComponents = URLComponents(url: authorizationURL, resolvingAgainstBaseURL: false)
        urlComponents?.setQueryItems(dict: queryItems)
        
        if let result = urlComponents?.url {
            return result
        } else {
            throw OAuthError() // TODO: replace with a better error
        }
    }
    
    
    /// Exchanges an authorization code for an access token
    /// - throws: InvalidAuthorizationCodeError() if the Authorization Code could not be validated
    public func exchange(authorizationCode: AuthorizationCode) throws -> Token {
        let queryItems = ["client_id": clientID,
                          "client_secret": clientSecret,
                          "redirect_uri": authorizationCode.redirectURL,
                          "code": authorizationCode.code]
        var urlComponents = URLComponents(url: tokenURL, resolvingAgainstBaseURL: false)
        urlComponents?.setQueryItems(dict: queryItems)
        
        guard let url = urlComponents?.url else {
            throw OAuthError() // TODO: replace with a better error
        }
        
        let request = try Request(method: .get, url: url)
        request.headers["Accept"] = "application/json"
        
        guard let response = try? HTTPClient.respond(to: request),
            let accessToken = response.json?["access_token"]?.string else {
                // TODO: actually handle this error
                throw UnsupportedCredentialsError()
        }
        return Token(token: accessToken)
    }
}

struct OAuthError: Error {
    
}

extension Request {
    convenience init(method: HTTP.Method, url: URL) throws {
        try self.init(method: method, uri: url.absoluteString)
    }
}

extension URLComponents {
    mutating func setQueryItems(dict: [String: String]) {
        self.queryItems = dict.map({URLQueryItem(name: $0, value: $1)})
    }
}
