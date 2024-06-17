//
//  SettingView.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

import SnapKit

final class SettingView: UIView, BaseViewBuildable {
    let tableView = UITableView()
    let settingOptions = SettingOptions.allCases
    var userData = UserData(
        userName: "",
        profileImage: ProfileImage.randomProfileImage,
        signUpDate: Date.now,
        likedItems: []
    ) {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    var delegate: (any BaseViewDelegate)?
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.register(SettingHeaderCell.self, forCellReuseIdentifier: SettingHeaderCell.identifier)
        tableView.register(MOTableViewCell.self, forCellReuseIdentifier: MOTableViewCell.identifier)
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? SettingViewControllerState {
            let userData = UserData(
                userName: state.userName,
                profileImage: state.profileImage,
                signUpDate: state.signUpDate,
                likedItems: state.likedItems
            )
            self.userData = userData
        }
    }
}


extension SettingView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return settingOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let  cell = tableView.dequeueReusableCell(withIdentifier: SettingHeaderCell.identifier, for: indexPath) as? SettingHeaderCell else { return UITableViewCell() }
            
            cell.configureData(userData)
            
            return cell
        } else {
            guard let  cell = tableView.dequeueReusableCell(withIdentifier: MOTableViewCell.identifier, for: indexPath) as? MOTableViewCell else { return UITableViewCell() }
            
            let settingOption = settingOptions[indexPath.row]
            
            switch settingOption {
            case .qna, .notification, .oneOnOneQuestion:
                cell.isUserInteractionEnabled = false
            default:
                break
            }
                
            let moCellData = MOButtonLabelData(
                leadingIconName: nil,
                leadingText: settingOption.leadingTitle,
                trailingButtonName: settingOption.trailingImageName,
                trailingButtonType: .assetImage,
                trailingText: settingOption.getTrailingText(userData.likedItems.count)
            )
            cell.configureData(moCellData)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        
        if section == 0 {
            delegate?.baseViewAction(.settingViewAction(.headerViewTapped))
        } else {
            let row = indexPath.row
            switch settingOptions[row] {
            case .liked:
                delegate?.baseViewAction(.settingViewAction(.likedItemsCellTapped))
            case .quit:
                delegate?.baseViewAction(.settingViewAction(.quitCellTapped))
            default:
                break
            }
        }
    }
}

