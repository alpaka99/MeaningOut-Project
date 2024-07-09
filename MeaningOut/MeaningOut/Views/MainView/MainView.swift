//
//  MainView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class MainView: BaseView {
    
    private(set) var searchBar = UISearchBar()
    private(set) var emptyView = UIImageView()
    private(set) var emptyLabel = UILabel()
    private(set) var headerView = MOButtonLabel()
    private(set) var tableView = UITableView()
    
    override internal func configureHierarchy() {
        super.configureHierarchy()
        self.addSubview(searchBar)
        self.addSubview(emptyView)
        self.addSubview(emptyLabel)
        self.addSubview(headerView)
        self.addSubview(tableView)
    }
    
    override internal func configureLayout() {
        super.configureLayout()
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
            $0.width.equalTo(self.snp.width)
                .multipliedBy(0.8)
            $0.height.equalTo(emptyView.snp.width)
                .multipliedBy(1)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.bottom)
                .offset(16)
            $0.horizontalEdges.equalTo(emptyView.snp.horizontalEdges)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
    }
    
    override internal func configureUI() {
        super.configureUI()
        
        
        searchBar.placeholder = MainViewConstants.searchBarPlaceholder
        
        emptyView.image = UIImage(named: ImageName.empty)
        emptyView.contentMode = .scaleAspectFill
        emptyLabel.text = MainViewConstants.emptyLabelText
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(
            ofSize: 16,
            weight: .heavy
        )
        
        headerView.alpha = 0
        headerView.setTrailingButtonColor(with: MOColors.moOrange.color)
        
        
        tableView.alpha = 0
        tableView.separatorColor = .clear
        tableView.selectionFollowsFocus = false
    }
}
