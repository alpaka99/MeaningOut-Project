//
//  ProfileSettingView.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

final class ProfileSettingView: UIView, BaseViewBuildable {
    let profileImage = ProfileImageView(profileImage: "profile_0", subImage: "camera.fill")
    let textField = MOTextField()
    let completeButton = RoundCornerButton(
        type: .plain,
        title: "완료",
        color: MOColors.moOrange.color
    )
    
//    weak var delegate: ProfileSettingViewDelegate?
    weak var delegate: BaseViewBuildableDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(profileImage)
        self.addSubview(textField)
        self.addSubview(completeButton)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
                .offset(16)
            $0.height.equalTo(self.snp.height)
                .multipliedBy(0.15)
            $0.width.equalTo(profileImage.snp.height)
                .multipliedBy(1)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom)
                .offset(32)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
       
        completeButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
                .offset(32)
            $0.horizontalEdges.equalTo(textField.snp.horizontalEdges)
            $0.height.equalTo(50)
        }
    }
    
    func configureUI() {
        self.backgroundColor = MOColors.moWhite.color
        
//        profileImage.delegate = self
//        completeButton.delegate = self
        
        profileImage.configureData()
    }
    
    func configureData() {
        
    }
    
}

extension ProfileSettingView: ProfileImageViewDelegate {
    func profileImageViewTapped() {
//        delegate?.toProfileSelectionViewController()
    }
}

extension ProfileSettingView: RoundCornerButtonDelegate {
    func roundCornerButtonTapped() {
//        delegate?.toNextViewController()
    }
}

protocol ProfileSettingViewDelegate: NSObject {
    func toNextViewController()
    func toProfileSelectionViewController()
}

