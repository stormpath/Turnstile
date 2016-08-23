//
//  URandomTests.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/3/16.
//
//

import XCTest
@testable import TurnstileCrypto

class URandomTests: XCTestCase {
    let random = URandom()
    
    func testThatRandomDoesntCrash() {
        _ = random.uint
        _ = random.uint8
        _ = random.uint16
        _ = random.uint32
        _ = random.uint64
        _ = random.int
        _ = random.int8
        _ = random.int16
        _ = random.int32
        _ = random.int64
    }
    
    func testRandomBytes() {
        measure { 
            let _ = self.random.random(numBytes: 500000)
        }
    }
    
    static var allTests = [
        ("testThatRandomDoesntCrash", testThatRandomDoesntCrash),
        ("testRandomBytes", testRandomBytes)
    ]
}
