//
//  ProfileSelectionViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewCell: UICollectionViewCell, BaseViewBuildable {
    
    internal let profileImage = ProfileImageView(profileImage: ProfileImage.randomProfileImage.rawValue)
    
    internal var delegate: BaseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureHierarchy() {
        self.addSubview(profileImage)
    }
    
    internal func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.edges.equalTo(self.snp.edges)
        }
    }
    
    internal func configureUI() {
        
    }
    
    internal func configureData(_ imageName: String) {
//        profileImage.profileImageView.image = UIImage(named: imageName)
        profileImage.setImage(ProfileImage.init(rawValue: imageName) ?? ProfileImage
            .randomProfileImage)
    }
    
    internal func configureData(_ state: any BaseViewControllerState) {
        
    }
    
    override func prepareForReuse() {
        profileImage.setSelectedState(as: .normal)
        profileImage.configureUI()
    }
}
