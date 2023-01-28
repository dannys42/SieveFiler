import XCTest
@testable import SieveFiler

final class FromDomainTests: XCTestCase {
    func testThat_OneDomain_WillFile() throws {
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

    func testThat_TwoDomains_WillFile() throws {
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

}
