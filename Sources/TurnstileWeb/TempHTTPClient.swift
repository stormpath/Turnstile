//
//  HTTPClient.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/30/16.
//
//

import HTTP
import Transport
import TLS

/// Temp HTTP client until we switch to Foundation
class TempHTTPClient: Responder {
    func respond(to request: Request) throws -> Response {
        let config = try Config(
            context: try Context(mode: .client),
            verifyCertificates: false
        )
        let client = try BasicClient(scheme: request.uri.scheme, host: request.uri.host, port: 443, securityLayer: .tls(config))
        
        return try client.respond(to: request)
    }
}
