//
//  ProfileSelectionViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewCell: UICollectionViewCell, BaseViewBuildable {
    
    let profileImage = ProfileImageView(profileImage: ProfileImage.randomProfileImage.rawValue)
    
    var delegate: BaseViewDelegate?
    
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
    
    func configureData(_ state: any BaseViewControllerState) {
        
    }
    
    override func prepareForReuse() {
        profileImage.selectedState = .normal
        profileImage.configureUI()
    }
}
