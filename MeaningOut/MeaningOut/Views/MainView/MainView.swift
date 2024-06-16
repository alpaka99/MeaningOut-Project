//
//  MainView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class MainView: UIView, BaseViewBuildable {
    let searchBar = UISearchBar()
    let emptyView = UIImageView()
    let emptyLabel = UILabel()
    let tableView = UITableView()
    
    var recentSearch: [String] = [] {
        didSet {
            recentSearchChanged()
        }
    }
    
    weak var delegate: BaseViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(emptyView)
        self.addSubview(emptyLabel)
        self.addSubview(tableView)
    }
    
    func configureLayout() {
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
        
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
                .offset(16)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
    }
    
    func configureUI() {
        backgroundColor = MOColors.moWhite.color
        
        searchBar.delegate = self
        
        emptyView.image = UIImage(named: "empty")
        emptyView.contentMode = .scaleAspectFill
        emptyLabel.text = "최근 검색어가 없어요"
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.register(MOTableViewCell.self, forCellReuseIdentifier: MOTableViewCell.identifier)
        tableView.alpha = 0
        tableView.separatorColor = .clear
        tableView.selectionFollowsFocus = false
        
    }
    
    func configureData() {
        
    }
    
    func recentSearchChanged() {
        if recentSearch.isEmpty {
            tableView.alpha = 0
            
            emptyView.alpha = 1
            emptyLabel.alpha = 1
        } else {
            emptyView.alpha = 0
            emptyLabel.alpha = 0
            
            tableView.alpha = 1
            tableView.reloadData()
        }
    }
    
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MOTableViewCell.identifier, for: indexPath) as? MOTableViewCell else { return UITableViewCell() }
        
        let data = recentSearch[indexPath.row]
        let cellData = MOCellData(
            leadingIconName: "clock",
            leadingText: data,
            trailingIconName: "xmark",
            trailingText: ""
        )
        cell.configureData(cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = recentSearch[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension MainView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty == false {
            recentSearch.append(text)
        }
    }
}
