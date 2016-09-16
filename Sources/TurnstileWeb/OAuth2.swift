//
//  OAuth2.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/7/16.
//
//

import Turnstile
import Foundation

/// Type for the mockable URL Session generator.
typealias HTTPClientGenerator = () -> HTTPClient

/**
 OAuth 2 represents the base API Client for an OAuth 2 server that implements the
 authorization code grant type. This is the typical redirect based login flow
 you see on .
 
 Since OAuth doesn't define token validation, implementing it is up to a subclass.
 */
open class OAuth2 {
    /// The Client ID for the OAuth 2 Server
    public let clientID: String
    
    /// The Client Secret for the OAuth 2 Server
    public let clientSecret: String
    
    /// The Authorization Endpoint of the OAuth 2 Server
    public let authorizationURL: URL
    
    /// The Token Endpoint of the OAuth 2 Server
    public let tokenURL: URL
    
    /// Mockable URL Session generator. Should be using epheremal sessions, but doesn't seem to work on linux
    var _urlSession: HTTPClientGenerator = { URLSession(configuration: URLSessionConfiguration.default) }
    
    /// We don't want URLSessions to store cookies, so we have to generate a new one for each request. 
    var urlSession: HTTPClient {
        return _urlSession()
    }
    
    
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
    /// - parameter scopes:      A list of OAuth scopes you'd like the user to grant
    open func getLoginLink(redirectURL: String, state: String, scopes: [String] = []) -> URL {
        let queryItems = ["response_type": "code",
                          "client_id": clientID,
                          "redirect_uri": redirectURL,
                          "state": state,
                          "scope": scopes.joined(separator: " ")]
        var urlComponents = URLComponents(url: authorizationURL, resolvingAgainstBaseURL: false)
        urlComponents?.setQueryItems(dict: queryItems)
        
        if let result = urlComponents?.url {
            return result
        } else {
            // Gotta fail gracefully.
            return URL(string: ".")!
        }
    }
    
    
    /// Exchanges an authorization code for an access token
    /// - throws: InvalidAuthorizationCodeError() if the Authorization Code could not be validated
    /// - throws: APIConnectionError() if we cannot connect to the OAuth server
    /// - throws: InvalidAPIResponse() if the server does not respond in a way we expect
    open func exchange(authorizationCode: AuthorizationCode) throws -> OAuth2Token {
        let postBody = ["grant_type": "authorization_code",
                        "client_id": clientID,
                        "client_secret": clientSecret,
                        "redirect_uri": authorizationCode.redirectURL,
                        "code": authorizationCode.code]
        let urlComponents = URLComponents(url: tokenURL, resolvingAgainstBaseURL: false)
        
        guard let url = urlComponents?.url else {
            throw InvalidInput()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setBodyURLEncoded(dict: postBody)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let data = (try? urlSession.executeRequest(request: request))?.0 else {
            throw APIConnectionError()
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
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
    open func exchange(authorizationCodeCallbackURL url: String, state: String) throws -> OAuth2Token {
        guard let urlComponents = URLComponents(string: url) else { throw InvalidAPIResponse() }
        
        guard let code = urlComponents.queryDictionary["code"],
            urlComponents.queryDictionary["state"] == state else {
                throw OAuth2Error(dict: urlComponents.queryDictionary) ?? InvalidAPIResponse()
        }
        
        let redirectURL = url.substring(to: url.range(of: "?")?.lowerBound ?? url.startIndex)
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

extension URLComponents {
    var queryDictionary: [String: String] {
        // URLQueryItems are messed up on Linux, so we'll do this instead:
        
        var result = [String: String]()
        
        guard let components = query?.components(separatedBy: "&") else {
            return result
        }
        
        components.forEach { component in
            let queryPair = component.components(separatedBy: "=")
            
            if queryPair.count == 2 {
                result[queryPair[0]] = queryPair[1]
            } else {
                result[queryPair[0]] = ""
            }
        }
        return result
    }
}

extension URLComponents {
    mutating func setQueryItems(dict: [String: String]) {
        // URLQueryItems are messed up on Linux, so we'll do this instead:
        query = dict.map { (key, value) in
            return key + "=" + value
            }.joined(separator: "&")
    }
}
extension URLRequest {
    mutating func setBodyURLEncoded(dict: [String: String]) {
        httpBody = dict.map { (key, value) in
            return key + "=" + value
            }
            .joined(separator: "&")
            .data(using: .utf8)
        
        setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}
