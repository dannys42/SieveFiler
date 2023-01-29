//
//  Match.swift
//  
//
//  Created by Danny Sung on 1/27/23.
//

import Foundation

@resultBuilder
public struct MatchBuilder {
    static public func buildBlock(_ components: Match...) -> [Match] {
        return components
    }
}

public protocol Match: UniqueKeys {
    var rawValues: [String] { get }

    func fileIntoRule(folder: Folder, fields: [Fields.Field]) -> [SieveSource]
}

