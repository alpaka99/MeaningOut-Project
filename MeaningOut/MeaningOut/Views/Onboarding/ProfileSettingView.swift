//
//  ProfileSettingView.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

final class ProfileSettingView: UIView, BaseViewBuildable {
    let profileImage = ProfileImageView(
        profileImage: ProfileImage.randomProfileImage.rawValue,
        subImage: ImageName.cameraFilled
    )
    let textField = MOTextField()
    let completeButton = RoundCornerButton(
        type: .plain,
        title: ProfileSettingViewConstants.completeButtonTitle,
        color: MOColors.moOrange.color
    )
    
    weak var delegate: BaseViewDelegate?
    
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
        
        profileImage.delegate = self
        profileImage.selectedState = .selected
        profileImage.setAsSelectedImage()
        
        textField.delegate = self
        
        completeButton.delegate = self
    }
    
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? ProfileSettingViewControllerState {
            profileImage.setImage(state.selectedImage)
            
            textField.configureData(state)
            
            switch state.profileSettingViewType {
            case .onBoarding:
                setAsOnBoardingType()
            case .setting:
                setAsSettingType()
            }
        }
    }
    
    func setAsOnBoardingType() {
        textField.setAsOnboardingType()
    }
    
    func setAsSettingType() {
        textField.setAsSettingType()
        completeButton.alpha = 0
    }
    
    func triggerAction() {
        textField.triggerAction()
    }
}


extension ProfileSettingView: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .profileImageAction(let action):
            switch action {
            case .profileImageTapped:
                profileImageTapped()
            }
        case .moTextFieldAction(let detailAction):
            switch detailAction {
            case .sendTextFieldText(let userName):
                sendTextFieldText(userName)
            case .textFieldTextChanged(let isEnabled):
                completeButton.isEnabled = isEnabled
                delegate?.baseViewAction(.profileSettingViewAction(.textFieldTextChanged(isEnabled)))
            }
        default:
            break
        }
    }
    
    func profileImageTapped() {
        delegate?.baseViewAction(.profileImageAction(.profileImageTapped))
    }
    
    func sendTextFieldText(_ userName: String) {
        
        delegate?.baseViewAction(.profileSettingViewAction(.completeButtonTapped(userName)))
    }
}

extension ProfileSettingView: RoundCornerButtonDelegate {
    func roundCornerButtonTapped(_ type: RoundCornerButtonType) {
        triggerAction()
    }
}
