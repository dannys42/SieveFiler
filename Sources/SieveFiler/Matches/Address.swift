//
//  Addresses.swift
//  
//
//  Created by Danny Sung on 1/29/23.
//

import Foundation

/// Match rule to match exactly the full email address given
public struct Addresses: Match {
    public let rawValues: [String]

    public let outputOrder: Int = 10

    public init(_ string: String...) {
        self.rawValues = string
    }

    public func fileIntoRule(folder: Folder, fields: [Fields.Field]) -> [SieveSource] {
        let fieldText: String
        if fields.count < 1 {
            return []
        } else {
            let fieldNames = fields.map({ "\"" + $0.rawValue + "\"" }).sorted().joined(separator: ", ")

            if fields.count == 1 {
                fieldText = fieldNames
            } else {
                fieldText = "[ " + fieldNames + " ]"
            }
        }
        return [SieveSource(order: .exactAddress,
        """
        if address :is :all \(fieldText) [
            \(self.rawValues.map({ "\""+$0+"\"" }).joined(separator: ",\n    "))
        ] {
            fileinto "\(folder.folder)";
            stop;
        }
        """)]
    }

    public func validate() throws {
        try Self.validate(domains: self.rawValues)
    }

    static func validate(domains: [String]) throws {
        for domain in domains {
            if !domain.contains("@") {
                throw AddressFailures.addressRequiresOneAtSymbol
            }
            if !domain.contains(".") {
                throw AddressFailures.addressRequiresOneDotSymbol
            }
            if domain.contains("*") {
                throw AddressFailures.addressMustNotContainAsteriskSymbol
            }

            if domain.hasPrefix("@") {
                throw AddressFailures.addressMustNotStartWithAtSymbol
            }
            if domain.hasPrefix(".") {
                throw AddressFailures.addressMustNotStartWithDotSymbol
            }

            if domain.hasSuffix("@") {
                throw AddressFailures.addressMustNotEndWithAtSymbol
            }

        }
    }
}

extension Addresses: UniqueKeys {
    public var uniqueKeys: [String] {
        return self.rawValues
    }
}
