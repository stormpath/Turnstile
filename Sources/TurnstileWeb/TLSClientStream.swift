/**
 Brought in from https://github.com/vapor/tls-provider 0.4
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

import TLS
import SecretSocks
import Transport

/**
    Establish a secure SSL/TLS connection to a remote server
*/
class TLSClientStream: TCPProgramStream, ClientStream {
    public func connect() throws -> Stream {
        try stream.connect()
        switch securityLayer {
        case .none:
            return stream
        case .tls:
            let secure = try stream.makeSecret(mode: .client)
            try secure.connect()
            return secure
        }
    }
}

/*
 Incomplete conformance of SSL.Socket. Will be updating with more thorough support
 */
extension TLS.Socket: Stream {
    // Timeout not supported
    public func setTimeout(_ timeout: Double) throws {}
    
    public var closed: Bool {
        return false
    }
    
    public func close() throws {
        //
    }
    
    
    public func flush() throws {
        // no flush, send immediately flushes
    }
}
