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

    enum Failures: Error {
        case existingRuleForFolder(String, String)
    }

    let folders: [Folder]

    public init(@SieveRulesBuilder _ content: () throws -> [Folder]) rethrows {
        self.folders = try content()
    }

    @discardableResult
    public func validate() throws -> Self {
        var existingRules: [String:String] = [:]
        for folder in folders {
            let keys = folder.fields.uniqueKeys
            for key in keys {
                if let destinationFolder = existingRules[key] {
                    if destinationFolder != folder.folder {
                        throw Failures.existingRuleForFolder(folder.folder, key)
                    }
                } else {
                    existingRules[key] = folder.folder
                }
            }

            try folder.validate()
        }

        return self
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

        sources = sources.sorted(by: { $0.outputOrder < $1.outputOrder })

        let header = """
                     require ["fileinto", "envelope", "regex"];

                     """

        let sourceText = sources.map { $0.string }
        return header + sourceText.joined(separator: "\n")
    }

    @discardableResult
    public func output(_ file: String, shouldValidate: Bool = true) throws -> Self {

        if shouldValidate {
            try self.validate()
        }

        let string = self.asString
        try string.write(toFile: file, atomically: true, encoding: .utf8)

        return self
    }
}

