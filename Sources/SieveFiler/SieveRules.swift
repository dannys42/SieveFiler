//
//  SieveRules.swift
//  
//
//  Created by Danny Sung on 1/27/23.
//

import Foundation

@resultBuilder
public struct SieveRulesBuilder {
    static public func buildBlock(_ components: Folder...) -> [Folder] {
        return components
    }
}

public struct SieveRules {

    let folders: [Folder]

    public init(@SieveRulesBuilder _ content: () -> [Folder]) {
        self.folders = content()
    }

    @discardableResult
    public func print() -> SieveRules {
//        Swift.print("\(#function): folders: \(self.folders)")
        let sourceText = self.asString

        Swift.print(sourceText)

        return self
    }

    public var asString: String {
        var sources: [SieveSource] = []

        for folder in folders {
            let folderSources = folder.sources()
            sources.append(contentsOf: folderSources)
        }

        let sourceText = sources.map { $0.string }
        return sourceText.joined(separator: "\n")
    }

    @discardableResult
    public func output(_ file: String) -> SieveRules {

        return self
    }
}

