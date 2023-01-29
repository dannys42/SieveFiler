//
//  Failures.swift
//  
//
//  Created by Danny Sung on 1/29/23.
//

import Foundation

public enum DomainFailures: Error {
    case domainMustNotContainAtSymbol
    case domainMustNotContainAsteriskSymbol
}
