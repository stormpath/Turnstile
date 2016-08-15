import XCTest
@testable import TurnstileTestSuite
@testable import TurnstileCryptoTestSuite
@testable import TurnstileWebTestSuite

XCTMain([
     testCase(SubjectTests.allTests),
     testCase(MemoryRealmTests.allTests),
     testCase(MemorySessionManagerTests.allTests),
     testCase(URandomTests.allTests),
     testCase(BCryptTests.allTests),
     testCase(FacebookTests.allTests),
     testCase(OAuth2Tests.allTests),
     testCase(TLSClientStreamTests.allTests)
])
