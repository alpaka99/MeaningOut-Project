//
//  MainViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit


final class MainViewController: BaseViewController<MainView> {
    internal struct State {
        var userData: UserData
        var searchHistory: [String]
    }
    
    internal var state: State = State(
        userData: UserData.dummyUserData() ,
        searchHistory: []
    ) {
        didSet {
//            configureData(state)
        }
    }
    
    private var recentSearch: [String] = [] {
        didSet {
            changeView()
        }
    }
    
    // tab을 넘어갔다가 와도 데이터를 업데이트 해주기 위해서
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserData()
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "\(state.userData.userName)" + MainViewConstants.navigationTitleSufix
    }
    
    override func configureDelegate() {
        baseView.searchBar.delegate = self
        
        baseView.tableView.delegate = self
        baseView.tableView.dataSource = self
        
        baseView.tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.identifier
        )
        baseView.tableView.register(
            MOTableViewCell.self,
            forCellReuseIdentifier: MOTableViewCell.identifier
        )
        
        baseView.headerView.trailingButton.addTarget(self, action: #selector(eraseAllHistoryButtonTapped), for: .touchUpInside)
    }
    
    private func loadUserData() {
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            state.userData = userData
        }
    }
    
    private func changeView() {
        if recentSearch.isEmpty {
            showEmptyView()
        } else {
            showTableView()
            baseView.tableView.reloadData()
        }
    }
    
    private func showTableView() {
        baseView.emptyView.alpha = 0
        baseView.emptyLabel.alpha = 0
        
        baseView.tableView.alpha = 1
        baseView.headerView.alpha = 1
        baseView.tableView.reloadData()
    }
    
    private func showEmptyView() {
        baseView.headerView.alpha = 0
        baseView.tableView.alpha = 0
        
        baseView.emptyView.alpha = 1
        baseView.emptyLabel.alpha = 1
    }
}

extension MainViewController {
    private func searchKeyword(_ keyword: String) {
        let searchResultViewController = SearchResultViewController(baseView: SearchResultView(), searchText: keyword)
        searchResultViewController.fetchSearchResult(
            keyword,
            sortOptions: .simularity
        )
        
        navigationController?.pushViewController(
            searchResultViewController,
            animated: true
        )
    }
    
    @objc
    private func eraseAllHistoryButtonTapped() {
        state.searchHistory = []
        baseView.tableView.reloadData()
    }
    
    @objc
    private func deleteButtonTapped(_ sender: UIButton) {
        recentSearch.remove(at: sender.tag)
    }
}


extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            if recentSearch.contains(text) == false {
                recentSearch.append(text)
            }
            searchKeyword(text)
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearch.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MOTableViewCell.identifier, for: indexPath) as? MOTableViewCell else { return UITableViewCell() }
        
        let data = recentSearch[indexPath.row]
        let cellData = MOButtonLabelData(
            leadingIconName: ImageName.clock,
            leadingText: data,
            trailingButtonName: ImageName.xmark,
            trailingButtonType: .systemImage,
            trailingText: nil
        )
        cell.configureData(cellData)
        
        cell.trailingButton.tag = indexPath.row
        cell.trailingButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = recentSearch[indexPath.row]
        baseView.searchBar.text = keyword

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
}
