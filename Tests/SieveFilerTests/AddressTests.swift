//
//  AddressTests.swift
//  
//
//  Created by Danny Sung on 1/29/23.
//

import XCTest
@testable import SieveFiler

final class AddressTests: XCTestCase {

    func testThat_OneAddress_WillFile() throws {
        let expectedValue = """
        require ["fileinto", "envelope", "regex"];
        
        if address :is :all "From" [
            "someone@domain1.com"
        ] {
            fileinto "Mailbox1";
            stop;
        }
        """

        let observedValue = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    Addresses("someone@domain1.com")
                }
            }
        }.asString

        XCTAssertEqual(observedValue, expectedValue)
    }

}
