//
//  MainView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class MainView: BaseView {
    
    private let searchBar = UISearchBar()
    private let emptyView = UIImageView()
    private let emptyLabel = UILabel()
    private let headerView = MOButtonLabel()
    private let tableView = UITableView()
    
    private var recentSearch: [String] = [] {
        didSet {
            changeView()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        showEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func configureHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(emptyView)
        self.addSubview(emptyLabel)
        self.addSubview(headerView)
        self.addSubview(tableView)
    }
    
    override internal func configureLayout() {
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
        backgroundColor = MOColors.moWhite.color
        
        searchBar.delegate = self
        searchBar.placeholder = MainViewConstants.searchBarPlaceholder
        
        emptyView.image = UIImage(named: ImageName.empty)
        emptyView.contentMode = .scaleAspectFill
        emptyLabel.text = MainViewConstants.emptyLabelText
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(
            ofSize: 16,
            weight: .heavy
        )
        
//        headerView.delegate = self
//        headerView.configureData(MOButtonLabelData(
//            leadingIconName: nil,
//            leadingText: MainViewConstants.headerViewLeadingText,
//            trailingButtonName: nil,
//            trailingButtonType: .plain,
//            trailingText: nil
//        ))
        headerView.alpha = 0
        headerView.setTrailingButtonColor(with: MOColors.moOrange.color)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.identifier
        )
        tableView.register(
            MOTableViewCell.self,
            forCellReuseIdentifier: MOTableViewCell.identifier
        )
        tableView.alpha = 0
        tableView.separatorColor = .clear
        tableView.selectionFollowsFocus = false
    }
    
    func configureData() {
        
    }
    
    private func changeView() {
        if recentSearch.isEmpty {
            showEmptyView()
        } else {
            showTableView()
            tableView.reloadData()
        }
    }
    
    
    private func showTableView() {
        emptyView.alpha = 0
        emptyLabel.alpha = 0
        
        tableView.alpha = 1
        headerView.alpha = 1
        tableView.reloadData()
    }
    
    private func showEmptyView() {
        headerView.alpha = 0
        tableView.alpha = 0
        
        emptyView.alpha = 1
        emptyLabel.alpha = 1
    }
    
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
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
//        cell.configureData(cellData)
//        cell.delegate = self
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = recentSearch[indexPath.row]
        searchBar.text = keyword
//        delegate?.baseViewAction(.mainViewAction(.searchKeyword(keyword)))
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
}


extension MainView: UISearchBarDelegate {
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty == false {
            // MARK: Call Delegate method to fetch NewData
//            delegate?.baseViewAction(.mainViewAction(.searchKeyword(text)))
        }
    }
}

//extension MainView: BaseViewDelegate {
//    internal func baseViewAction(_ type: BaseViewActionType) {
//        switch type {
//        case .moButtonLabelAction(let detailAction):
//            switch detailAction {
//            case .trailingButtonTapped(let moCellData):
//                deleteButtonTapped(moCellData)
//            case .eraseAllHistoryButtonTapped:
//                eraseAllButtonTapped()
//            }
//        default:
//            break
//        }
//    }
//    
//    private func deleteButtonTapped(_ moCellData: MOButtonLabelData) {
//        delegate?.baseViewAction(.mainViewAction(.deleteButtonTapped(moCellData)))
//    }
//    
//    private func eraseAllButtonTapped() {
//        delegate?.baseViewAction(.mainViewAction(.eraseAllHistoryButtonTapped))
//    }
//}
