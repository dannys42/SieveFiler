//
//  File.swift
//  
//
//  Created by Danny Sung on 1/27/23.
//

import Foundation

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
        return [SieveSource(
        """
        if address :is :domain \(fieldText) [
            \(self.rawValues.map({ "\""+$0+"\"" }).joined(separator: ",\n    "))
        ] {
            fileinto "\(folder.folder)";
            stop;
        }
        """)]
    }
}
