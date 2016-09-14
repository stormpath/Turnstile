//
//  Random.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/3/16.
//
//

/**
 Random is a pluggable random number generator that depends on the OS provided.
 */
public protocol Random {
    
    /// Get a byte array of random UInt8s
    func random(numBytes: Int) -> [UInt8]
    
    /// Get a random int8
    var int8: Int8 { get }
    
    /// Get a random uint8
    var uint8: UInt8 { get }
    
    /// Get a random int16
    var int16: Int16 { get }
    
    /// Get a random uint16
    var uint16: UInt16 { get }
    
    /// Get a random int32
    var int32: Int32 { get }
    
    /// Get a random uint32
    var uint32: UInt32 { get }
    
    /// Get a random int64
    var int64: Int64 { get }
    
    /// Get a random uint64
    var uint64: UInt64 { get }
    
    /// Get a random int
    var int: Int { get }
    
    /// Get a random uint
    var uint: UInt { get }
    
    /// Get a random string usable for authentication purposes
    var secureToken: String { get }
}
