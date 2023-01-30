//
//  SieveSource.swift
//  
//
//  Created by Danny Sung on 1/27/23.
//

import Foundation

public struct SieveSource {
    public enum Order: Int {
        case exactAddress
        case exactDomain
        case anySubdomain
    }

    let outputOrder: Int

    let string: String

    init(order: Order, _ string: String) {
        self.outputOrder = order.rawValue
        self.string = string
    }
}
