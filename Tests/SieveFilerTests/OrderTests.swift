//
//  OrderTests.swift
//  
//
//  Created by Danny Sung on 1/29/23.
//

import XCTest
@testable import SieveFiler

final class OrderTests: XCTestCase {

    func testThat_OutputOrder_Is_Address_Domain_Subdomain() throws {
        let expectedValue = """
        if address :is :all "From" [
            "someone@domain1.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        if address :is :domain "From" [
            "domain2.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        if address :is :domain "From" [
            "domain1.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        if address :match :domain "From" [
            "*.domain1.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        """

        let observedValue = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    Domains("domain2.com")
                }
            }
            Folder("Mailbox1") {
                Fields(.from) {
                    SubDomains("domain1.com")
                }
            }
            Folder("Mailbox1") {
                Fields(.from) {
                    Addresses("someone@domain1.com")
                }
            }
        }.asString

        XCTAssertEqual(observedValue, expectedValue)
    }

}