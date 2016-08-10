//
//  OAuth2Error.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/9/16.
//
//

import Turnstile
import JSON

/**
 An OAuth 2 error is an error recieved from an OAuth 2 server.
 Typical examples are defined in https://tools.ietf.org/html/rfc6749#section-5.2
 All OAuth errors will have a string conversion.
 */
public struct OAuth2Error: TurnstileError {
    public let code: OAuth2ErrorCode
    public let description: String
    public let uri: String
    
    /// Initializer an OAuth error with a code, description, and uri
    public init(code: OAuth2ErrorCode, description: String? = nil, uri: String? = nil) {
        self.code = code
        self.description = description ?? code.rawValue
        self.uri = uri ?? ""
    }
    
    /// Convenience initializer from JSON
    init?(json: JSON) {
        guard let errorCode = json["error"]?.string,
              let code = OAuth2ErrorCode(rawValue: errorCode) else {
                return nil
        }
        self.init(code: code, description: json["error_description"]?.string, uri: json["error_uri"]?.string)
    }
    
    /// Convenience initializer from a dictionary representing the JSON or URL parameters
    public init?(dict: [String: String]) {
        guard let errorCode = dict["error"],
            let code = OAuth2ErrorCode(rawValue: errorCode) else {
                return nil
        }
        self.init(code: code, description: dict["error_description"], uri: dict["error_uri"])
    }
}

/**
 OAuth 2 Error Codes
 */
public enum OAuth2ErrorCode: String {
    /// The request sent to the OAuth 2 server was invalid
    case invalidRequest = "invalid_request",
    
    /// Client authentication failed
    invalidClient = "invalid_client",
    
    /// The authorization grant (code, password, etc) is invalid
    invalidGrant = "invalid_grant",
    
    /// The client is not authorized to make this request
    unauthorizedClient = "unauthorized_client",
    
    /// The grant type is not supported by the server
    unsupportedGrantType = "unsupported_grant_type",
    
    /// A scope requested is invalid
    invalidScope = "invalid_scope",
    
    /// The user or server denied this request
    accessDenied = "access_denied",
    
    /// The server does not support an authorization code using this method
    unsupportedResponseType = "unsupported_response_type",
    
    /// An internal server error occurred
    serverError = "server_error",
    
    /// The OAuth server is busy
    temporarilyUnavailable = "temporarily_unavailable"
}

/// The API Response was not expected. This could be an API server error or library error
public struct InvalidAPIResponse: TurnstileError {
    /// User-presentable error message
    public let description = "Invalid API Response"
    
    /// Empty initializer
    public init() {}
}

/// We could not establish a connection to this API server
public struct APIConnectionError: TurnstileError {
    /// User-presentable error message
    public let description = "Unable to connect to the external API"
    
    /// Empty initializer
    public init() {}
}
