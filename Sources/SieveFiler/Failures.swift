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

public enum AddressFailures: Error {
    case addressRequiresOneAtSymbol
    case addressRequiresOneDotSymbol
    case addressMustNotContainAsteriskSymbol
    case addressMustNotStartWithAtSymbol
    case addressMustNotStartWithDotSymbol
    case addressMustNotEndWithAtSymbol
}
