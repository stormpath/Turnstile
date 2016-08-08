//
//  Message+JSON.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/8/16.
//
//

import HTTP
import JSON

/**
 Taken from https://github.com/vapor/vapor 0.16. MIT Licensed
 */
extension Message {
    var json: JSON? {
        get {
            if let existing = storage["json"] as? JSON {
                return existing
            } else if let type = headers["Content-Type"], type.contains("application/json") {
                guard case let .data(body) = body else { return nil }
                guard let json = try? JSON(bytes: body) else { return nil }
                storage["json"] = json
                return json
            } else {
                return nil
            }
        }
    }
}
