//
//  ProfileSelectionViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewCell: UICollectionViewCell, BaseViewBuildable {
    
    let profileImage = ProfileImageView(profileImage: "profile_0")
    
    var delegate: BaseViewBuildableDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(profileImage)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.edges.equalTo(self.snp.edges)
        }
    }
    
    func configureUI() {
        
    }
    
    func configureData(_ imageName: String) {
        profileImage.profileImageView.image = UIImage(named: imageName)
    }
}
