//
//  OAuthEcho.swift
//  Turnstile
//
//  Created by Kaden Wilkinson on 11/12/16.
//
//

import Foundation
import Turnstile

/**
 The OAuth Echo credential represents the info sent to the server for delegated OAuth 1.0a
 This is an extension mainly used by Twitter/Digits
 See: 
  * https://dev.twitter.com/oauth/echo
  * http://oauthbible.com/#oauth-10a-echo
  * https://docs.fabric.io/apple/digits/advanced-setup.html#verifying-a-user
 */
public class OAuthEcho: Credentials {
    /**
     The auth provider for this set of credentials. Usually passed via
     the `X-Auth-Service-Provider` header
     */
    public let authServiceProvider: URL
    
    /**
     The OAuth parameters passed in through either the `X-Verify-Credentials-Authorization`
     header or body parameters.
     */
    public let oauthParameters: OAuthParameters
    
    /// Initializer for OAuth Echo credential data
    public init(authServiceProvider: URL, oauthParameters: OAuthParameters) {
        self.authServiceProvider = authServiceProvider
        self.oauthParameters = oauthParameters
    }
}
