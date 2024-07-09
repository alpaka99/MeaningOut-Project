//
//  LikedItemsView.swift
//  MeaningOut
//
//  Created by user on 7/8/24.
//

import UIKit

import SnapKit

final class LikedItemsView: UIView {
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionView.createFlowLayout(
            numberOfRowsInLine: 2,
            spacing: 20,
            heightMultiplier: 2
        ))
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(collectionView)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        self.backgroundColor = MOColors.moWhite.color
    }
}

