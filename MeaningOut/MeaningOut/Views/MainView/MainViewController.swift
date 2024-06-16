//
//  MainViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit


final class MainViewController: MOBaseViewController, CommunicatableBaseViewController {
    struct State: MainViewControllerState {
        var searchHistory: [String]
    }
    
    var state: State = State(searchHistory: []) {
        didSet {
            configureData(state)
        }
    }
    
    override func configureUI() {
        baseView.delegate = self
    }
}

extension MainViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .mainViewAction(let detailAction):
            switch detailAction {
            case .searchKeyword(let keyword):
                searchKeyword(keyword)
            case .eraseAllHistoryButtonTapped:
                eraseAllHistoryButtonTapped()
            case .deleteButtonTapped(let moCellData):
                deleteButtonTapped(moCellData)
            }
        default:
            break
        }
    }
    
    
    func searchKeyword(_ keyword: String) {
        if state.searchHistory.contains(keyword) == false {
            state.searchHistory.append(keyword)
        }
        
        let searchResultViewController = SearchResultViewController(SearchResultView())
        searchResultViewController.fetchSearchResult(keyword, filterOption: .simularity)
        
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
    
    func eraseAllHistoryButtonTapped() {
        state.searchHistory = []
    }
    
    func deleteButtonTapped(_ moCellData: MOButtonLabelData) {
        for i in 0..<state.searchHistory.count {
            let searchHistory = state.searchHistory[i]
            if searchHistory == moCellData.leadingText {
                state.searchHistory.remove(at: i)
                return
            }
        }
    }
}
