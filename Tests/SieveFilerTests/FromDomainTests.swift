import XCTest
@testable import SieveFiler

final class FromDomainTests: XCTestCase {
    func testThat_OneDomain_WillCreateOneFile() throws {
        let expectedValue = """
        if address :is :domain "From" [
            "domain.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        """

        let observedValue = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    Domains("domain.com")
                }
            }
        }.asString

        XCTAssertEqual(observedValue, expectedValue)
    }

    func testThat_TwoDomains_WillCreateOneFile() throws {
        let expectedValue = """
        if address :is :domain "From" [
            "somedomain.com",
            "anotherdomain.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        """

        let observedValue = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    Domains("somedomain.com", "anotherdomain.com")
                }
            }
        }.asString

        XCTAssertEqual(observedValue, expectedValue)
    }

    func testThat_TwoFolders_WillCreateTwoFiles() throws {
        let expectedValue = """
        if address :is :domain "From" [
            "domain1.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        if address :is :domain "From" [
            "domain2.com"
        ] {
            fileinto "Mailbox2";
            stop;
        }
        """

        let observedValue = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    Domains("domain1.com")
                }
            }
            Folder("Mailbox2") {
                Fields(.from) {
                    Domains("domain2.com")
                }
            }
        }.asString

        XCTAssertEqual(observedValue, expectedValue)
    }


    func testThat_SameDomainSameField_InDifferentFolders_WillError() throws {
       let rules = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    Domains("domain1.com")
                }
            }
            Folder("Mailbox2") {
                Fields(.from) {
                    Domains("domain1.com")
                }
            }
        }

        try XCTExpectFailure {
            try rules.validate()
        }
    }

    func testThat_SameDomainDifferentFields_WillGoIntoDifferentFolders() throws {
        let rules = SieveRules {
             Folder("Mailbox1") {
                 Fields(.from) {
                     Domains("domain1.com")
                 }
             }
             Folder("Mailbox2") {
                 Fields(.replyTo) {
                     Domains("domain1.com")
                 }
             }
        }

        try rules.validate() // should not throw
    }
}
