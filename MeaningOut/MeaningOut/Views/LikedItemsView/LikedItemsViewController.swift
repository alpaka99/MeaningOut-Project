//
//  LikedItemsViewController.swift
//  MeaningOut
//
//  Created by user on 7/8/24.
//

import UIKit

import RealmSwift

final class LikedItemsViewController: UIViewController {
    
    private var likedItems = RealmRepository.shared.readAll(of: LikedItems.self)
    private var baseView = LikedItemsView()
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likedItems = RealmRepository.shared.readAll(of: LikedItems.self)
        baseView.collectionView.reloadData()
    }
    
    func configureDelegate() {
        baseView.collectionView.delegate = self
        baseView.collectionView.dataSource = self
        baseView.collectionView.register(
            SearchResultCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier
        )
    }
    
    @objc
    func likedButtonTapped(_ sender: UIButton) {
        print(#function)
        let index = sender.tag
        
        let target = likedItems[index]
        
        RealmRepository.shared.delete(target)
        
        baseView.collectionView.reloadData()
    }
}
extension LikedItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        cell.likeButton.tag = indexPath.row
        
        let data = likedItems[indexPath.row]
        
        do {
            try MOImageManager.shared.fetchImage(
                objectName: getTypeName(),
                urlString: data.image
            ) { image in
                cell.setImage(with: image)
            }
        } catch NetworkError.urlNotGenerated {
            print("Check Image URL")
        } catch {
            print(error.localizedDescription)
        }
        
        cell.likeButton.addTarget(
            self,
            action: #selector(likedButtonTapped),
            for: .touchUpInside
        )
        
        cell.configureRealmData(data)
        
        cell.toggleIsLiked()
        cell.setAsLikeItem()
        
        return cell
    }
}
