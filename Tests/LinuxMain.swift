import XCTest
@testable import TurnstileTests
@testable import TurnstileCryptoTests
@testable import TurnstileWebTests

XCTMain([
     testCase(SubjectTests.allTests),
     testCase(MemoryRealmTests.allTests),
     testCase(MemorySessionManagerTests.allTests),
     testCase(URandomTests.allTests),
     testCase(BCryptTests.allTests),
     testCase(FacebookTests.allTests),
     testCase(OAuth2Tests.allTests),
     testCase(WebMemoryRealmTests.allTests)
])
