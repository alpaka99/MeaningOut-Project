//
//  SearchResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import Kingfisher
import SnapKit

final class SearchResultCollectionViewCell: UICollectionViewCell, BaseViewBuildable {
    let itemImage = UIImageView()
    let likeButton = UIButton()
    let mallName = UILabel()
    let title = UILabel()
    let price = UILabel()
    
    var delegate: (any BaseViewDelegate)?
    
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
        contentView.addSubview(itemImage)
        itemImage.addSubview(likeButton)
        contentView.addSubview(mallName)
        contentView.addSubview(title)
        contentView.addSubview(price)
    }
    
    func configureLayout() {
        itemImage.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.width.equalTo(contentView.snp.width)
            $0.height.equalTo(itemImage.snp.width)
                .multipliedBy(1.2)
            $0.horizontalEdges.equalTo(contentView)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        likeButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(itemImage)
                .inset(16)
        }
        
        mallName.snp.makeConstraints {
            $0.top.equalTo(itemImage.snp.bottom)
                .offset(4)
            $0.horizontalEdges.equalTo(contentView)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(mallName.snp.bottom)
                .offset(4)
            $0.horizontalEdges.equalTo(contentView)
        }
        
        price.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom)
                .offset(4)

        }
    }
    
    func configureUI() {
        itemImage.layer.cornerRadius = 8
        itemImage.clipsToBounds = true
        
        likeButton.setImage(UIImage(systemName: "cart"), for: .normal)
        likeButton.backgroundColor = MOColors.moGray300.color.withAlphaComponent(0.5)
        likeButton.tintColor = .white
        likeButton.layer.cornerRadius = 8
        
        mallName.textColor = MOColors.moGray300.color
        mallName.font = .systemFont(ofSize: 12, weight: .regular)
        
        title.textColor = .black
        title.font = .systemFont(ofSize: 12, weight: .medium)
        
        price.textColor = .black
        title.font = .systemFont(ofSize: 16, weight: .heavy)
    }
    
    func configureData(_ item: ShoppingItem) {
        if let url = URL(string: item.image) {
            itemImage.kf.setImage(with: url)
        }
        
        
        mallName.text = item.mallName
        
        title.text = item.title
        
        let formattedPrice = Int(item.lprice)?.formatted() ?? "0"
        price.text = formattedPrice + "원"
    }
    
}
