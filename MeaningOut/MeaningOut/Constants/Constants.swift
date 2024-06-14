//
//  Constants.swift
//  MeaningOut
//
//  Created by user on 6/13/24.
//

import UIKit

enum MOColors: CaseIterable {
    case moOrange
    case moBlack
    case moGray100
    case moGray200
    case moGray300
    case moWhite
    
    
    var color: UIColor {
        switch self {
        case .moOrange:
            return UIColor.hexToColor("#EF8947") ?? .clear
        case .moBlack:
            return UIColor.hexToColor("#000000") ?? .clear
        case .moGray100:
            return UIColor.hexToColor("#4C4C4C") ?? .clear
        case .moGray200:
            return UIColor.hexToColor("#828282") ?? .clear
        case .moGray300:
            return UIColor.hexToColor("#CDCDCD") ?? .clear
        case .moWhite:
            return UIColor.hexToColor("#FFFFFF") ?? .clear
        }
    }
}
