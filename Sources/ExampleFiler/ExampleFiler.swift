//
//  main.swift
//  
//
//  Created by Danny Sung on 1/26/23.
//

import ArgumentParser
import SieveFiler

@main
struct Repeat: ParsableCommand {
    /*
    @Flag(help: "Include a counter with each repetition.")
    var includeCounter = false

    @Option(name: .shortAndLong, help: "The number of times to repeat 'phrase'.")
    var count: Int? = nil

    @Argument(help: "The phrase to repeat.")
    var phrase: String
     */

    mutating func run() throws {

            SieveRules {
                Folder("SomeMailbox") {
                    Fields(.replyTo, .from) {
                        Domains("abc", "def")
                    }
                }
            }
            .print()
            .output("xyz")

    }
}
