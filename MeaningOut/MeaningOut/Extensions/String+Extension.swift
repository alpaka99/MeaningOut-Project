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
}
