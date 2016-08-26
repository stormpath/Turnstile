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
import URI
import Transport

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
    
    let HTTPClient = BasicClient.self
    
    
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
        loginLink += "&scope=" + scopes.joined(separator: "%20")
        
        return loginLink
    }
    
    
    /// Exchanges an authorization code for an access token
    /// - throws: InvalidAuthorizationCodeError() if the Authorization Code could not be validated
    /// - throws: APIConnectionError() if we cannot connect to the OAuth server
    /// - throws: InvalidAPIResponse() if the server does not respond in a way we expect
    public func exchange(authorizationCode: AuthorizationCode) throws -> OAuth2Token {
        // TODO: serialize these better
        let url = tokenURL + "?grant_type=authorization_code&client_id=\(clientID)&redirect_uri=\(authorizationCode.redirectURL)&client_secret=\(clientSecret)&code=\(authorizationCode.code)"
        let request = try! Request(method: .post, uri: url)
        
        request.headers["Accept"] = "application/json"
        
        guard let response = try? HTTPClient.respond(to: request) else {
            throw APIConnectionError()
        }
        guard let json = response.json else {
            throw InvalidAPIResponse()
        }
        guard let token = OAuth2Token(json: json) else {
            // Facebook doesn't do this error properly... probably have to override this
            if let error = OAuth2Error(json: json) {
                throw error
            } else {
                throw InvalidAPIResponse()
            }
        }
        return token
    }
    
    /// Parses a URL and exchanges the OAuth 2 access token and exchanges it for a
    /// - throws: InvalidAuthorizationCodeError() if the Authorization Code could not be validated
    /// - throws: APIConnectionError() if we cannot connect to the OAuth server
    /// - throws: InvalidAPIResponse() if the server does not respond in a way we expect
    /// - throws: OAuth2Error() if the oauth server calls back with an error
    public func exchange(authorizationCodeCallbackURL url: String, state: String) throws -> OAuth2Token {
        guard let uri = try? URI(url), let query = uri.queryDictionary else { throw InvalidAPIResponse() }
        
        guard let code = query["code"], query["state"] == state else {
            throw OAuth2Error(dict: query) ?? InvalidAPIResponse()
        }
        
        let redirectURL = url.substring(to: url.range(of: "?")!.lowerBound)
        return try exchange(authorizationCode: AuthorizationCode(code: code, redirectURL: redirectURL))
    }
    
    // TODO: add refresh token support
}

public extension Realm where Self: OAuth2 {
    public func authenticate(authorizationCodeCallbackURL url: String, state: String) throws -> Account {
        let token = try exchange(authorizationCodeCallbackURL: url, state: state)
        return try self.authenticate(credentials: token.accessToken)
    }
    
    public func authenticate(authorizationCode: AuthorizationCode) throws -> Account {
        let token = try exchange(authorizationCode: authorizationCode)
        return try self.authenticate(credentials: token.accessToken)
    }
}

private extension URI {
    var queryDictionary: [String: String]? {
        guard let queryComponents = self.query?.components(separatedBy: "&") else { return nil }
        
        var result = [String: String]()
        for component in queryComponents {
            let pair = component.components(separatedBy: "=")
            
            if pair.count == 2 {
                result[pair[0]] = pair[1]
            }
        }
        return result
    }
}
