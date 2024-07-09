//
//  ProfileSelectionViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewCell: BaseCollectionViewCell {
    
    internal let profileImage = ProfileImageView(profileImage: ProfileImage.randomProfileImage.rawValue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func configureHierarchy() {
        self.addSubview(profileImage)
    }
    
    override internal func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.edges.equalTo(self.snp.edges)
        }
    }
    
    override internal func configureUI() {
        
    }
    
    internal func configureData(_ imageName: String) {
        profileImage.setImage(ProfileImage.init(rawValue: imageName) ?? ProfileImage
            .randomProfileImage)
    }
    
    
    override func prepareForReuse() {
        profileImage.setSelectedState(as: .normal)
        profileImage.configureUI()
    }
}
