//
//  ErrorTypes.swift
//  MeaningOut
//
//  Created by user on 6/18/24.
//

enum StringValidationError: Error {
    case isNil
    case isEmpty
    case isShort
    case isLong
    case isUsingSpecialLetter
    case isUsingNumeric
}

enum NetworkError: Error {
    case urlNotGenerated
}
