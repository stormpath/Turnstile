import XCTest
@testable import TurnstileTestSuite
@testable import TurnstileCryptoTestSuite

XCTMain([
     testCase(UserTests.allTests),
     testCase(URandomTests.allTests)
])
