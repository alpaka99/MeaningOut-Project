//
//  ProfileImageView.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

final class ProfileImageView: UIView, BaseViewBuildable {
    
    let profileImageView = UIImageView()
    let subButton = UIImageView()
    
    weak var delegate: BaseViewBuildableDelegate?
    
    init(
        profileImage: String,
        subImage: String? = nil,
        action: (()->())? = nil
    ) {
        self.profileImageView.image = UIImage(named: profileImage)
        if let subImage = subImage {
            self.subButton.image = UIImage(systemName: subImage)
        } else {
            self.subButton.isHidden = true
            self.subButton.alpha = 0
        }
        
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
    
    func configureHierarchy() {
        self.addSubview(profileImageView)
        self.addSubview(subButton)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
            $0.height.equalTo(self.snp.height)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        subButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImageView)
            
            $0.size.equalTo(profileImageView.snp.size)
                .multipliedBy(0.3)
        }
    }
    
    func configureUI() {
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = MOColors.moOrange.color.cgColor
        profileImageView.contentMode = .scaleToFill
        
        subButton.contentMode = .scaleAspectFit
        subButton.tintColor = MOColors.moWhite.color
        subButton.backgroundColor = MOColors.moOrange.color
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
    }
    
    func roundCorners() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        subButton.layer.cornerRadius = subButton.frame.height / 2
    }
    
    func configureData() {
        
    }
    
    @objc
    func profileImageTapped() {
//        delegate?.profileImageViewTapped()
    }
}


protocol ProfileImageViewDelegate: AnyObject {
    func profileImageViewTapped()
}
