//
//  String+Extension.swift
//  MeaningOut
//
//  Created by user on 6/13/24.
//

extension String {
    func removeOnePrefix(_ prefix: String) -> Self? {
        if self.hasPrefix(prefix) {
            let secondIndex = self.index(
                self.startIndex,
                offsetBy: 1
            )
            let result = String(self[secondIndex...])
            return result
        }
        return nil
    }
    
    static var emptyString: String {
        return ""
    }
}

extension String? {
    internal func validateNickname() throws -> String {
        do {
            let unWrappedNickName = try self.checkNil()
            
            try unWrappedNickName.checkIsEmpty()
            try unWrappedNickName.checkStringLength()
            try unWrappedNickName.checkContainsSpecialLetter()
            try unWrappedNickName.checkNumeric()
            
            return unWrappedNickName
        } catch {
            throw error
        }
    }
    
    private func checkNil() throws -> String {
        guard let unwrappedSelf = self  else { throw StringValidationError.isNil }
        return unwrappedSelf
    }
}

extension String {
    internal func checkIsEmpty() throws {
        guard self.isEmpty == false else { throw StringValidationError.isEmpty }
    }
    
    internal func checkStringLength() throws {
        guard self.count >= 2 else { throw StringValidationError.isShort }
        guard self.count <= 10 else { throw StringValidationError.isLong }
    }
    
    internal func checkContainsSpecialLetter() throws {
        let specialLetters: [Character] = SpecialLetterConstants.allStringCases
        
        try specialLetters.forEach { specialLetter in
            if self.contains(where: {$0 == specialLetter}) {
                throw StringValidationError.isUsingSpecialLetter
            }
        }
    }
    
    internal func checkNumeric() throws {
        guard !self.contains(where: {$0.isNumber}) else { throw StringValidationError.isUsingNumeric }
    }
}
