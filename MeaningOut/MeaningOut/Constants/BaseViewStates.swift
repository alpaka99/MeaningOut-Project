//
//  BaseViewStates.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//


protocol MainViewControllerState: BaseViewControllerState {
    var searchHistory: [String] { get set }
}


protocol SearchResultViewControllerState: BaseViewControllerState {
    var searchResult: NaverShoppingResponse { get set }
}

protocol MOButtonLabelState: BaseViewControllerState {
    var leadingIconName: String { get set }
    var leadingText: String { get set }
    var trailingButtonName: String { get set }
    var trailingText: String { get set }
}
