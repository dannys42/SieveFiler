//
//  SubDomainTests.swift
//  
//
//  Created by Danny Sung on 1/29/23.
//

import XCTest
@testable import SieveFiler

final class SubDomainTests: XCTestCase {


    func testThat_FromOneSubdomain_WillCreateFileRules() {
        let expectedValue = """
        if address :is :domain "From" [
            "domain1.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        if address :matches :domain "From" [
            "*.domain1.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        """

        let observedValue = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    SubDomains("domain1.com")
                }
            }
        }.asString

        XCTAssertEqual(observedValue, expectedValue)

    }
}
