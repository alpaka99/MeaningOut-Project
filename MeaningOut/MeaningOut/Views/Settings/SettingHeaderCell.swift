//
//  SettingHeaderCell.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

import SnapKit

final class SettingHeaderCell: UITableViewCell, BaseViewBuildable {
    let profileImage = ProfileImageView(profileImage: ProfileImage.randomProfileImage.rawValue)
    let userNameLabel = UILabel()
    let signUpDateLabel = UILabel()
    let trailingIcon = UIImageView()
    
    var delegate: (any BaseViewDelegate)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImage)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(signUpDateLabel)
        contentView.addSubview(trailingIcon)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.width.equalTo(contentView.snp.width)
                .multipliedBy(0.2)
            $0.height.lessThanOrEqualTo(profileImage.snp.width)
            $0.leading.equalTo(contentView.snp.leading)
                .offset(8)
            $0.verticalEdges.equalTo(contentView.snp.verticalEdges)
                .inset(8)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing)
                .offset(8)
            $0.centerY.equalTo(profileImage.snp.centerY)
                .offset(-16)
        }
        
        signUpDateLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing)
                .offset(8)
            $0.centerY.equalTo(profileImage.snp.centerY)
                .offset(16)
        }
        
        trailingIcon.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing)
                .offset(-8)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
    }
    
    func configureUI() {
        profileImage.setImage(.profile_10)
        profileImage.selectedState = .selected
        profileImage.setAsSelectedImage()
        
        userNameLabel.text = "옹골찬 고래밥"
        signUpDateLabel.text = Date.now.formatted()
        trailingIcon.image = UIImage(systemName: "chevron.right")
        trailingIcon.tintColor = .black
        
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? UserData {
            
            profileImage.setImage(state.profileImage)
            userNameLabel.text = state.userName
            signUpDateLabel.text = state.signUpDate.formatted()
        }
    }
}
