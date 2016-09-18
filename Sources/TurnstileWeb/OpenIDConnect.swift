//
//  OpenIDConnect.swift
//  Turnstile
//
//  Created by Harlan Haskins on 9/17/16.
//
//

import Foundation
import Turnstile

/**
  An OpenID Connect authorization class, that's generic over the user account
  type. You must subclass this class.
 */
open class OpenIDConnect<AccountType>: OAuth2, Realm {
  let userDataURL: URL
  
  /**
   Create an OpenID Connect object set to the URLs passed in.
   */
  public init(clientID: String, clientSecret: String,
              authorizationURL: URL, tokenURL: URL, userDataURL: URL) {
    self.userDataURL = userDataURL
    super.init(clientID: clientID, clientSecret: clientSecret,
               authorizationURL: authorizationURL, tokenURL: tokenURL)
  }
  
  /**
   Authenticates an OpenID Connect access token.
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
   Creates a URLRequest that asks for the user data associated with a set of
   credentials.
   Different OpenID providers ask for credentials in different ways -- many use
   Authorization headers, some use URL parameters.
   The default behavior is to add "Authorization: Bearer: <token>" to the request.
   */
  public func authenticatedRequest(credentials: AccessToken) -> URLRequest {
    var request = URLRequest(url: userDataURL)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer: \(credentials.string)", forHTTPHeaderField: "Authorization")
    return request
  }
  
  /**
    Authenticates an OpenID Connect access token and provides an account object.
   */
  public func authenticate(credentials: AccessToken) throws -> AccountType {
    let request = authenticatedRequest(credentials: credentials)
    
    guard let data = (try? urlSession.executeRequest(request: request))?.0 else {
      throw APIConnectionError()
    }
    
    guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
      throw InvalidAPIResponse()
    }
    
    return try makeAccount(json: json)
  }
  
  /**
    Creates an account object from the JWT returned by the OpenID server.
    The default behavior is to throw an IncorrectCredentialsError(), so
    subclasses must override this method.
    */
  open func makeAccount(json: [String: Any]) throws -> AccountType {
    throw IncorrectCredentialsError()
  }
  
  open override func getLoginLink(redirectURL: String, state: String, scopes: [String] = ["profile"]) -> URL {
    return super.getLoginLink(redirectURL: redirectURL, state: state, scopes: scopes)
  }
}
