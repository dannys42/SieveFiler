//
//  SubDomains.swift
//
//
//  Created by Danny Sung on 1/29/23.
//

import Foundation

/// Match rule to match either the domain given or any subdomains
public struct SubDomains: Match {
    public let rawValues: [String]

    public let outputOrder: Int = 30

    public init(_ subdomain: String...) {
        self.init(subdomain)
    }

    public init(_ subdomains: [String]) {
        self.rawValues = subdomains
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
        return [
            SieveSource(order: .exactDomain,
            """
            if address :is :domain \(fieldText) [
                \(self.rawValues.map({ "\""+$0+"\"" }).joined(separator: ",\n    "))
            ] {
                fileinto "\(folder.folder)";
                stop;
            }
            """),
            SieveSource(order: .anySubdomain,
            """
            if address :match :domain \(fieldText) [
                \(self.rawValues.map({ "\"*."+$0+"\"" }).joined(separator: ",\n    "))
            ] {
                fileinto "\(folder.folder)";
                stop;
            }
            """),
        ]
    }

    public func validate() throws {
        try Domains.validate(domains: self.rawValues)
    }
}

extension SubDomains: UniqueKeys {
    public var uniqueKeys: [String] {
        return self.rawValues + self.rawValues.map({ "*." + $0 })
    }
}
