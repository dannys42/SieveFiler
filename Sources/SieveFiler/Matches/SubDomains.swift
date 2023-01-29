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
        return [
            SieveSource(
            """
            if address :is :domain \(fieldText) [
                \(self.rawValues.map({ "\""+$0+"\"" }).joined(separator: ",\n    "))
            ] {
                fileinto "\(folder.folder)";
                stop;
            }
            """),
            SieveSource(
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
}

extension SubDomains: UniqueKeys {
    public var uniqueKeys: [String] {
        return self.rawValues + self.rawValues.map({ "*." + $0 })
    }
}
