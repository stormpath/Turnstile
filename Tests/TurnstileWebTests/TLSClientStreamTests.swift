#if os(Linux)
/**
 Brought in from https://github.com/vapor/tls-provider.
 Attribution and Copyright below:
 
 The MIT License (MIT)
 
 Copyright (c) 2016 Tanner Nelson
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import XCTest
@testable import TurnstileWeb

class TLSClientStreamTests: XCTestCase {
    static var allTests = [
        ("testSend", testSend)
    ]

    func testSend() {
        do {
            let clientStream = try TLSClientStream.init(host: "api.spotify.com", port: 443, securityLayer: .tls).connect()
            let uri = "/v1/search?type=artist&q=hannah%20diamond"
            try clientStream.send("GET \(uri) HTTP/1.1\r\nHost: api.spotify.com\r\n\r\n".bytes)
            let response = try clientStream.receive(max: 2048).string

            XCTAssert(response.contains("spotify:artist:3sXErEOw7EmO6Sj7EgjHdU"))
        } catch {
            XCTFail("Could not send: \(error)")
        }
    }
}

extension Sequence where Iterator.Element == UInt8 {
    /**
        Converts a slice of bytes to
        string. Courtesy of Socks by @Czechboy0
    */
    public var string: String {
        var utf = UTF8()
        var gen = makeIterator()
        var str = String()
        while true {
            switch utf.decode(&gen) {
            case .emptyInput:
                return str
            case .error:
                break
            case .scalarValue(let unicodeScalar):
                str.append(unicodeScalar)
            }
        }
    }
}

extension String {
    var bytes: [UInt8] {
        return Array(utf8)
    }
}
#endif
