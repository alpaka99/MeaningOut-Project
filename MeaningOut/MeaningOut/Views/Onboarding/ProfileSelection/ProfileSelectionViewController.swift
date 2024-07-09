//
//  ProfileSelectionViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewController: BaseViewController<ProfileSelectionView> {
    
    var viewModel = ProfileSelectionViewModel()
    
    convenience init(
        baseView: ProfileSelectionView,
        selectedImage: ProfileImage
    ) {
        self.init(baseView: baseView)
        viewModel.selectedImage.value = selectedImage
    }
    
    internal weak var delegate: ProfileSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.profileCollectionView.delegate = self
        baseView.profileCollectionView.dataSource = self
        
        baseView.profileCollectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionViewCell.identifier
        )
        baseView.profileCollectionView.register(
            ProfileSelectionViewCell.self,
            forCellWithReuseIdentifier: ProfileSelectionViewCell.identifier
        )
    }
    
    func bindData() {
        viewModel.selectedImage.actionBind { [weak self] value in
            self?.baseView.selectedImageView.setImage(value)
        }
    }
}


extension ProfileSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profileImages.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileSelectionViewCell.identifier,
            for: indexPath
        ) as? ProfileSelectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.profileImages[indexPath.row]
        cell.configureData(data.rawValue)
        if data == viewModel.selectedImage.value {
            cell.profileImage.setSelectedState(as: .selected)
            cell.profileImage.setAsSelectedImage()
        }
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedImage.value = viewModel.profileImages[indexPath.row]
        baseView.selectedImageView.setImage(viewModel.selectedImage.value)
        
        collectionView.reloadData()
        
        delegate?.profileImageSelected(viewModel.selectedImage.value)
    }
}

protocol ProfileSelectionViewControllerDelegate: AnyObject {
    func profileImageSelected(_ image: ProfileImage)
}
