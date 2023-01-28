//
//  Fields.swift
//  
//
//  Created by Danny Sung on 1/27/23.
//

import Foundation


public struct Fields {
    public enum Field: String {
        case from = "From"
        case replyTo = "Reply-To"
    }

    let fields: [Field]
    let matches: [any Match]

    public init(_ field: Field, _ additionalFields: Field..., @MatchBuilder matches: () -> [any Match]) {

        self.fields = [field] + additionalFields
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
