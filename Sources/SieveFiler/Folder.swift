//
//  Folder.swift
//  
//
//  Created by Danny Sung on 1/26/23.
//

import Foundation

@resultBuilder
public struct FolderBuilder {
    static public func buildBlock(_ components: Fields...) -> [Fields] {
        return components
    }
}

public struct Folder {
    let folder: String
    let fields: [Fields]

    public init(_ folder: String, @FolderBuilder _ content: () -> [Fields]) {
        self.folder = folder
        self.fields = content()
    }

    func sources() -> [SieveSource] {
        var sources: [SieveSource] = []
        for field in fields {
            let fieldSources = field.sources(folder: self)
            sources.append(contentsOf: fieldSources)
        }
        return sources
    }
}

extension Folder: Identifiable {
    public var id: String {
        return self.folder
    }
}


extension Folder: UniqueKeys {
    public var uniqueKeys: [String] {
        var returnValues: [String] = []

        for fields in self.fields {
            for field in fields.fields {
                returnValues.append(self.folder + "|" + field.rawValue)
            }
        }

        return returnValues
    }
}
