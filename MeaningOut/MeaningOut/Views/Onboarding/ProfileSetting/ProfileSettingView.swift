//
//  ProfileSettingView.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

final class ProfileSettingView: BaseView {
    private(set) var profileImage = ProfileImageView(
        profileImage: ProfileImage.randomProfileImage.rawValue,
        subImage: ImageName.cameraFilled
    )
    private(set) var textField = MOTextField()
    private(set) var completeButton = RoundCornerButton(
        type: .plain,
        title: ProfileSettingViewConstants.completeButtonTitle,
        color: MOColors.moOrange.color
    )
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func configureHierarchy() {
        self.addSubview(profileImage)
        self.addSubview(textField)
        self.addSubview(completeButton)
    }
    
    override internal func configureLayout() {
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
    
    override internal func configureUI() {
        self.backgroundColor = MOColors.moWhite.color
        
        profileImage.setSelectedState(as: .selected)
        profileImage.setAsSelectedImage()
    }
    
    internal func setAsOnBoardingType() {
        textField.setAsOnboardingType()
    }
    
    internal func setAsSettingType() {
        textField.setAsSettingType()
        completeButton.alpha = 0
    }
}