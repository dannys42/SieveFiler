//
//  ValidationTests.swift
//  
//
//  Created by Danny Sung on 1/29/23.
//

import XCTest
@testable import SieveFiler

final class ValidationTests: XCTestCase {


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

    func testThat_SameDomainAndSubdomain_InDifferentFolders_WillError() throws {
       let rules = SieveRules {
            Folder("Mailbox1") {
                Fields(.from) {
                    Domains("domain1.com")
                }
            }
            Folder("Mailbox2") {
                Fields(.from) {
                    SubDomains("domain1.com")
                }
            }
        }

        _ = try XCTExpectFailure {
            try rules.validate()
        }
    }

    // MARK: - Enforce valid domain symbols

    func testThat_Domain_CannotHaveAtSymbol() throws {
        let rules = SieveRules {
             Folder("Mailbox1") {
                 Fields(.from) {
                     Domains("@domain1.com")
                 }
             }
         }

         _ = try XCTExpectFailure {
             try rules.validate()
         }
    }

    func testThat_SubDomain_CannotHaveAsteriskSymbol() throws {
        let rules = SieveRules {
             Folder("Mailbox1") {
                 Fields(.from) {
                     Domains("*.domain1.com")
                 }
             }
         }

         _ = try XCTExpectFailure {
             try rules.validate()
         }
    }


    // MARK: Enforce valid address symbols
    func testThat_Address_CannotHaveAsteriskSymbol() throws {
        let rules = SieveRules {
             Folder("Mailbox1") {
                 Fields(.from) {
                     Domains("someone*@domain1.com")
                 }
             }
         }

         _ = try XCTExpectFailure {
             try rules.validate()
         }
    }

    func testThat_Address_MustHaveAtSymbol() throws {
        let rules = SieveRules {
             Folder("Mailbox1") {
                 Fields(.from) {
                     Addresses("domain1.com")
                 }
             }
         }

         _ = try XCTExpectFailure {
             try rules.validate()
         }
    }

    func testThat_Address_MustHaveDotSymbol() throws {
        let rules = SieveRules {
             Folder("Mailbox1") {
                 Fields(.from) {
                     Addresses("someone@domain1_com")
                 }
             }
         }

         _ = try XCTExpectFailure {
             try rules.validate()
         }
    }

    func testThat_Address_MustNotStartWithAtSymbol() throws {
        let rules = SieveRules {
             Folder("Mailbox1") {
                 Fields(.from) {
                     Addresses("@domain1.com")
                 }
             }
         }

         _ = try XCTExpectFailure {
             try rules.validate()
         }
    }


}
