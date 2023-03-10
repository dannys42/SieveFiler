//
//  Fields.swift
//  
//
//  Created by Danny Sung on 1/27/23.
//

import Foundation


public struct Fields {
    public enum Field: String, CaseIterable, Identifiable {
        case from = "From"
        case replyTo = "Reply-To"
        case to = "To"
        case cc = "Cc"
        case bcc = "Bcc"

        public var id: String {
            return self.rawValue
        }
    }

    let fields: [Field]
    let matches: [any Match]

    public init(_ field: Field, _ additionalFields: Field..., @MatchBuilder matches: () -> [any Match]) {

        self.init([field] + additionalFields, matches: matches)
    }

    public init(_ fields: [Field], @MatchBuilder matches: () -> [any Match]) {
        self.fields = fields
        self.matches = matches()
    }

    public func sources(folder: Folder) -> [SieveSource] {
        var sources: [SieveSource] = []
        for match in matches {
            let matchSources = match.fileIntoRule(folder: folder, fields: self.fields)
            sources.append(contentsOf: matchSources)
        }

        return sources
    }
}

extension Fields: UniqueKeys {
    public var uniqueKeys: [String] {
        var returnValues: [String] = []

        for field in self.fields {
            for match in self.matches {
                for matchKey in match.uniqueKeys {
                    returnValues.append(field.rawValue + "|" + matchKey)
                }
            }
        }

        return returnValues
    }
}

extension [Fields]: UniqueKeys {
    public var uniqueKeys: [String] {
        var returnValues: [String] = []

        for field in self {
            returnValues.append(contentsOf: field.uniqueKeys)
        }
        
        return returnValues
    }
}

extension Fields: HasValidation {
    public func validate() throws {
        for match in self.matches {
            try match.validate()
        }
    }
}
