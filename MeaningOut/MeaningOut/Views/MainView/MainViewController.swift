//
//  MainViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit


final class MainViewController: MOBaseViewController, CommunicatableBaseViewController {
    internal struct State: MainViewControllerState {
        var userData: UserData
        var searchHistory: [String]
    }
    
    internal var state: State = State(
        userData: UserData.dummyUserData() ,
        searchHistory: []
    ) {
        didSet {
            configureUI()
            configureData(state)
        }
    }
    
    // tab을 넘어갔다가 와도 데이터를 업데이트 해주기 위해서
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserData()
    }
    
    override func configureUI() {
        baseView.delegate = self
        
        navigationItem.title = "\(state.userData.userName)" + MainViewConstants.navigationTitleSufix
    }
    
    private func loadUserData() {
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            state.userData = userData
        }
    }
}

extension MainViewController: BaseViewDelegate {
    internal func baseViewAction(_ type: BaseViewActionType) {
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
    
    
    private func searchKeyword(_ keyword: String) {
        if state.searchHistory.contains(keyword) == false {
            state.searchHistory.append(keyword)
        }
        
        let searchResultViewController = SearchResultViewController(SearchResultView())
        searchResultViewController.fetchSearchResult(
            keyword,
            filterOption: .simularity
        )
        
        navigationController?.pushViewController(
            searchResultViewController,
            animated: true
        )
    }
    
    private func eraseAllHistoryButtonTapped() {
        state.searchHistory = []
    }
    
    private func deleteButtonTapped(_ moCellData: MOButtonLabelData) {
        for i in 0..<state.searchHistory.count {
            let searchHistory = state.searchHistory[i]
            if searchHistory == moCellData.leadingText {
                state.searchHistory.remove(at: i)
                return
            }
        }
    }
}
