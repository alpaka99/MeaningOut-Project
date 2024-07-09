//
//  ProfileSelectionView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionView: BaseView {
    private let selectedImageView: ProfileImageView = ProfileImageView(profileImage: ProfileImage.randomProfileImage.rawValue)
    private lazy var profileCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout(
            numberOfRowsInLine: 4,
            spacing: 20
        ))
    
    private let profileImages = ProfileImage.allCases
    private var selectedImage: ProfileImage = ProfileImage.randomProfileImage {
        didSet {
            selectedImageView.setImage(selectedImage)
        }
    }
    
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
        self.addSubview(selectedImageView)
        self.addSubview(profileCollectionView)
    }
    
    override internal func configureLayout() {
        selectedImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
                .offset(16)
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(self.snp.width)
                .multipliedBy(0.2)
            $0.height.equalTo(selectedImageView.snp.width)
                .multipliedBy(1)
        }
        
        profileCollectionView.snp.makeConstraints {
            $0.top.equalTo(selectedImageView.snp.bottom)
                .offset(40)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override internal func configureUI() {
        self.backgroundColor = .white
        
        selectedImageView.setSelectedState(as: .selected)
        selectedImageView.setAsSelectedImage()
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        profileCollectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionViewCell.identifier
        )
        profileCollectionView.register(
            ProfileSelectionViewCell.self,
            forCellWithReuseIdentifier: ProfileSelectionViewCell.identifier
        )
    }
    
//    override internal func configureData(_ state: any BaseViewControllerState) {
//        if let state = state as? ProfileSelectionViewControllerState {
//            selectedImage = state.selectedImage
//            selectedImageView.setImage(state.selectedImage)
//        }
//    }
}

extension ProfileSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    internal func createFlowLayout(numberOfRowsInLine: CGFloat, spacing: CGFloat) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let lengthOfALine = ScreenSize.width - (spacing * CGFloat(2 + numberOfRowsInLine - 1))
        let length = lengthOfALine / numberOfRowsInLine
        
        flowLayout.itemSize = CGSize(width: length, height: length)
        
        return flowLayout
    }

    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileSelectionViewCell.identifier,
            for: indexPath
        ) as? ProfileSelectionViewCell else { return UICollectionViewCell() }
        
        let data = profileImages[indexPath.row]
        cell.configureData(data.rawValue)
        if data == selectedImage {
            cell.profileImage.setSelectedState(as: .selected)
            cell.profileImage.setAsSelectedImage()
        }
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = profileImages[indexPath.row]
        selectedImageView.setImage(selectedImage)
        
        collectionView.reloadData()
        
//        delegate?.baseViewAction(.profileSelectionAction(.profileImageCellTapped(selectedImage)))
    }
}
