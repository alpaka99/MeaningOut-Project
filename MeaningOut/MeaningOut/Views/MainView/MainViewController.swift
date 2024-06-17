//
//  MainViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit


final class MainViewController: MOBaseViewController, CommunicatableBaseViewController {
    struct State: MainViewControllerState {
        var userData: UserData
        var searchHistory: [String]
    }
    
    var state: State = State(
        userData: UserData(
            userName: "",
            profileImage: ProfileImage.randomProfileImage,
            signUpDate: Date.now,
            likedItems: []) ,
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
        
        navigationItem.title = "\(state.userData.userName)님의 MeaningOut"
    }
    
    func loadUserData() {
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            state.userData = userData
        }
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
