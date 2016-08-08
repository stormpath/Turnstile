//
//  AuthorizationCode.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/7/16.
//
//

import Turnstile

public struct AuthorizationCode: Credentials {
    let code: String
    let redirectURI: String
}
