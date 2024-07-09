//
//  SettingView.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

import SnapKit

final class SettingView: BaseView {
    private(set) var tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func configureHierarchy() {
        self.addSubview(tableView)
    }
    
    override internal func configureLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override internal func configureUI() {
        super.configureUI()
        self.backgroundColor = .white
        
    }
    
//    internal func configureData(_ state: any BaseViewControllerState) {
//        if let state = state as? SettingViewControllerState {
//            let userData = UserData(
//                userName: state.userName,
//                profileImage: state.profileImage,
//                signUpDate: state.signUpDate,
//                likedItems: state.likedItems
//            )
//            self.userData = userData
//        }
//    }
}


    
    
//    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let section = indexPath.section
//        
//        if section == 0 {
//            delegate?.baseViewAction(.settingViewAction(.headerViewTapped))
//        } else {
//            let row = indexPath.row
//            switch settingOptions[row] {
//            case .liked:
//                delegate?.baseViewAction(.settingViewAction(.likedItemsCellTapped))
//            case .quit:
//                delegate?.baseViewAction(.settingViewAction(.quitCellTapped))
//            default:
//                break
//            }
//        }
//    }

