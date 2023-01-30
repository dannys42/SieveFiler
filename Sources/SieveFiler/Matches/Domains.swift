//
//  Domains.swift
//  
//
//  Created by Danny Sung on 1/27/23.
//

import Foundation

/// Match rule to match exactly domain name given
public struct Domains: Match {
    public let rawValues: [String]

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
        return [SieveSource(order: .exactDomain,
        """
        if address :is :domain \(fieldText) [
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
            if domain.contains("@") {
                throw DomainFailures.domainMustNotContainAtSymbol
            }
            if domain.contains("*") {
                throw DomainFailures.domainMustNotContainAsteriskSymbol
            }

        }
    }
}

extension Domains: UniqueKeys {
    public var uniqueKeys: [String] {
        return self.rawValues
    }
}
