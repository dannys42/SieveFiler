//
//  UniqueKeys.swift
//  
//
//  Created by Danny Sung on 1/29/23.
//

import Foundation

public protocol UniqueKeys {
    var uniqueKeys: [String] { get }
}

public protocol HasValidation {
    func validate() throws
}
