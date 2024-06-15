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
    var selectedState = ProfileImageState.normal
    
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
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = MOColors.moGray100.color.cgColor
        profileImageView.alpha = 0.5
        profileImageView.contentMode = .scaleToFill
        
        
        subButton.contentMode = .scaleAspectFit
        subButton.tintColor = MOColors.moWhite.color
        subButton.backgroundColor = MOColors.moOrange.color
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func roundCorners() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        subButton.layer.cornerRadius = subButton.frame.height / 2
    }
    
    func setImage(_ profileImage: String) {
        profileImageView.image = UIImage(named: profileImage)
    }
    
    func setAsSelectedImage() {
        selectedState = .selected
        profileImageView.layer.borderWidth = 3
        profileImageView.alpha = 1
        profileImageView.layer.borderColor = MOColors.moOrange.color.cgColor
    }
    
    @objc
    func profileImageTapped() {
        
    }
}


protocol ProfileImageViewDelegate: AnyObject {
    func profileImageViewTapped()
}

enum ProfileImageState {
    case selected
    case normal
}
