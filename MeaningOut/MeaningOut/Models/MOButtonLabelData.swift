//
//  MOCellData.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//
import UIKit

struct MOButtonLabelData: MOButtonLabelState {
    var leadingIconName: String
    var leadingText: String
    var trailingButtonName: String
    var trailingButtonType: MOButtonLabelTrailingButtonType
    var trailingText: String
}

enum MOButtonLabelTrailingButtonType {
    case image
    case plain
}
