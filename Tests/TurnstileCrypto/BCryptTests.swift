//
//  BCryptTests.swift
//  Turnstile
//
//  Created by Edward Jiang on 8/4/16.
//
//
//

/**
 Taken from the CryptoKitten repository. Attribution below:
 
 Copyright (c) 2016 Robbert Brandsma & Joannis Orlandos
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import XCTest
@testable import TurnstileCrypto

class BCryptTests: XCTestCase {
    let tests = [
        ("", "$2a$06$DCq7YPn5Rq63x1Lad4cll.", "$2a$06$DCq7YPn5Rq63x1Lad4cll.TV4S6ytwfsfvkgY8jIucDrjc8deX1s.", 6),
        ("", "$2a$08$HqWuK6/Ng6sg9gQzbLrgb.", "$2a$08$HqWuK6/Ng6sg9gQzbLrgb.Tl.ZHfXLhvt/SgVyWhQqgqcZ7ZuUtye", 8),
        ("", "$2a$10$k1wbIrmNyFAPwPVPSVa/ze", "$2a$10$k1wbIrmNyFAPwPVPSVa/zecw2BCEnBwVS2GbrmgzxFUOqW9dk4TCW", 10),
        ("", "$2a$12$k42ZFHFWqBp3vWli.nIn8u", "$2a$12$k42ZFHFWqBp3vWli.nIn8uYyIkbvYRvodzbfbK18SSsY.CsIQPlxO", 12),
        ("a", "$2a$06$m0CrhHm10qJ3lXRY.5zDGO", "$2a$06$m0CrhHm10qJ3lXRY.5zDGO3rS2KdeeWLuGmsfGlMfOxih58VYVfxe", 6),
        ("a", "$2a$08$cfcvVd2aQ8CMvoMpP2EBfe", "$2a$08$cfcvVd2aQ8CMvoMpP2EBfeodLEkkFJ9umNEfPD18.hUF62qqlC/V.", 8),
        ("a", "$2a$10$k87L/MF28Q673VKh8/cPi.", "$2a$10$k87L/MF28Q673VKh8/cPi.SUl7MU/rWuSiIDDFayrKk/1tBsSQu4u", 10),
        ("a", "$2a$12$8NJH3LsPrANStV6XtBakCe", "$2a$12$8NJH3LsPrANStV6XtBakCez0cKHXVxmvxIlcz785vxAIZrihHZpeS", 12),
        ("abc", "$2a$06$If6bvum7DFjUnE9p2uDeDu", "$2a$06$If6bvum7DFjUnE9p2uDeDu0YHzrHM6tf.iqN8.yx.jNN1ILEf7h0i", 6),
        ("abc", "$2a$08$Ro0CUfOqk6cXEKf3dyaM7O", "$2a$08$Ro0CUfOqk6cXEKf3dyaM7OhSCvnwM9s4wIX9JeLapehKK5YdLxKcm", 8),
        ("abc", "$2a$10$WvvTPHKwdBJ3uk0Z37EMR.", "$2a$10$WvvTPHKwdBJ3uk0Z37EMR.hLA2W6N9AEBhEgrAOljy2Ae5MtaSIUi", 10),
        ("abc", "$2a$12$EXRkfkdmXn2gzds2SSitu.", "$2a$12$EXRkfkdmXn2gzds2SSitu.MW9.gAVqa9eLS1//RYtYCmB1eLHg.9q", 12),
        ("abcdefghijklmnopqrstuvwxyz", "$2a$06$.rCVZVOThsIa97pEDOxvGu", "$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhstC", 6),
        ("abcdefghijklmnopqrstuvwxyz", "$2a$08$aTsUwsyowQuzRrDqFflhge", "$2a$08$aTsUwsyowQuzRrDqFflhgekJ8d9/7Z3GV3UcgvzQW3J5zMyrTvlz.", 8),
        ("abcdefghijklmnopqrstuvwxyz", "$2a$10$fVH8e28OQRj9tqiDXs1e1u", "$2a$10$fVH8e28OQRj9tqiDXs1e1uxpsjN0c7II7YPKXua2NAKYvM6iQk7dq", 10),
        ("abcdefghijklmnopqrstuvwxyz", "$2a$12$D4G5f18o7aMMfwasBL7Gpu", "$2a$12$D4G5f18o7aMMfwasBL7GpuQWuP3pkrZrOAnqP.bmezbMng.QwJ/pG", 12),
        ("~!@#$%^&*()      ~!@#$%^&*()PNBFRD", "$2a$06$fPIsBO8qRqkjj273rfaOI.", "$2a$06$fPIsBO8qRqkjj273rfaOI.HtSV9jLDpTbZn782DC6/t7qT67P6FfO", 6),
        ("~!@#$%^&*()      ~!@#$%^&*()PNBFRD", "$2a$08$Eq2r4G/76Wv39MzSX262hu", "$2a$08$Eq2r4G/76Wv39MzSX262huzPz612MZiYHVUJe/OcOql2jo4.9UxTW", 8),
        ("~!@#$%^&*()      ~!@#$%^&*()PNBFRD", "$2a$10$LgfYWkbzEvQ4JakH7rOvHe", "$2a$10$LgfYWkbzEvQ4JakH7rOvHe0y8pHKF9OaFgwUZ2q7W2FFZmZzJYlfS", 10),
        ("~!@#$%^&*()      ~!@#$%^&*()PNBFRD", "$2a$12$WApznUOJfkEGSmYRfnkrPO", "$2a$12$WApznUOJfkEGSmYRfnkrPOr466oFDCaj4b6HY3EXGvfxm43seyhgC", 12)
    ]
    
    let falseTests = [
        ("a", "$2a$06$DCq7YPn5Rq63x1Lad4cll.", "$2a$06$DCq7YPn5Rq63x1Lad4cll.TV4S6ytwfsfvkgY8jIucDrjc8deX1s.", 6),
        ("ab", "$2a$06$m0CrhHm10qJ3lXRY.5zDGO", "$2a$06$m0CrhHm10qJ3lXRY.5zDGO3rS2KdeeWLuGmsfGlMfOxih58VYVfxe", 6),
        ("abc", "$2a$06$If6bvum7DFjUnE9p2uDeDa", "$2a$06$If6bvum7DFjUnE9p2uDeDuaYHzrHM6tf.iqN8.yx.jNN1ILEf7h0i", 6),
        ("abcdefghijklmnopqrstuvwxyz", "$2a$06$.rCVZVOThsIa97pEDOxvGu", "$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhsta", 6),
        ("~!@#$%^&*()      ~!@#$%^&*()PNBFRa", "$2a$06$fPIsBO8qRqkjj273rfaOIa", "$2a$06$fPIsBO8qRqkjj273rfaOI.HtSV9jLDpTbZn782DC6/t7qT67P6Ffa", 6),
        ]
    
    func testBCryptVerify() throws {
        for test in tests {
            XCTAssert(try BCrypt.verify(password: test.0, matchesHash: test.2))
        }
        
        for test in falseTests {
            do {
                if try BCrypt.verify(password: test.0, matchesHash: test.2) {
                    XCTFail()
                }
            } catch { }
        }
    }
    
    func testBCryptGeneratesSalts() {
        let salt = BCrypt.generateSalt()
        let salt12 = BCrypt.generateSalt(rounds: 12)
        
        XCTAssert(salt.hasPrefix("$2a$10"), "The prefix should be $2a (for BCrypt) and $10 (iterations)")
        XCTAssertEqual(salt.characters.count, 29, "The salt should always be 29 characters")
        
        XCTAssert(salt12.hasPrefix("$2a$12"), "The prefix should be $2a (for BCrypt) and $12 (iterations)")
        XCTAssertEqual(salt12.characters.count, 29, "The salt should always be 29 characters")
    }
    
    func testBCryptHashesPasswordsProperly() throws {
        for test in tests {
            XCTAssertEqual(try BCrypt.hash(password: test.0, withSalt: test.1), test.2, "The hashed password should match the precomputed hash")
        }
    }
    
    // TODO: should test for BCrypt error conditions too
    
    static var allTests = [
        ("testBCryptVerify", testBCryptVerify),
        ("testBCryptGeneratesSalts", testBCryptGeneratesSalts),
        ("testBCryptHashesPasswordsProperly", testBCryptHashesPasswordsProperly)
    ]
}

extension String {
    internal subscript (i: Int) -> Character {
        return self[index(self.startIndex, offsetBy: i)]
    }
    
    internal subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    internal subscript (r: Range<Int>) -> String {
        let r2 = Range.init(uncheckedBounds: (lower: index(startIndex, offsetBy: r.lowerBound), upper: index(startIndex, offsetBy: r.upperBound)))
        
        return substring(with: r2)
    }
}
