//
//  ProfileImageView.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

final class ProfileImageView: BaseView {
    
    private let profileImageView = UIImageView()
    private let subButton = UIImageView()
    private var selectedState = ProfileImageType.normal
    
    internal func setSelectedState(as: ProfileImageType) {
        
    }
    
    init(
        profileImage: String,
        subImage: String? = nil
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
    
    override internal func configureHierarchy() {
        self.addSubview(profileImageView)
        self.addSubview(subButton)
    }
    
    override internal func configureLayout() {
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
    
    override internal func configureUI() {
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = MOColors.moGray100.color.cgColor
        profileImageView.alpha = 0.5
        profileImageView.contentMode = .scaleToFill
        
        
        subButton.contentMode = .scaleAspectFit
        subButton.tintColor = MOColors.moWhite.color
        subButton.backgroundColor = MOColors.moOrange.color
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(profileImageTapped)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Async하게 수정
    private func roundCorners() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        subButton.layer.cornerRadius = subButton.frame.height / 2
    }
    
    internal func setImage(_ image: ProfileImage) {
        profileImageView.image = UIImage(named: image.rawValue)
    }
    
    internal func setAsSelectedImage() {
        profileImageView.layer.borderWidth = 3
        profileImageView.alpha = 1
        profileImageView.layer.borderColor = MOColors.moOrange.color.cgColor
    }
    
    @objc
    private func profileImageTapped() {
//        delegate?.baseViewAction(.profileImageAction(.profileImageTapped))
    }
}
