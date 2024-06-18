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
    let likeButton = RoundCornerButton(
        type: .image,
        image: UIImage(named: "like_unselected"),
        color: MOColors.moGray100.color.withAlphaComponent(0.3)
    )
    let mallName = UILabel()
    let title = UILabel()
    let price = UILabel()
    var isLiked = false
    
    var shoppingItem = ShoppingItem(
        title: "",
        image: "",
        mallName: "",
        lprice: "",
        link: "",
        productId: ""
    )
    
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
    
    override func prepareForReuse() {
        likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
    }
    
    func configureHierarchy() {
        contentView.addSubview(itemImage)
        contentView.addSubview(likeButton)
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
        
        if isLiked == false {
            likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
        }
        likeButton.backgroundColor = MOColors.moGray300.color.withAlphaComponent(0.5)
        likeButton.tintColor = .white
        likeButton.layer.cornerRadius = 8
        likeButton.delegate = self
        
        mallName.textColor = MOColors.moGray300.color
        mallName.font = .systemFont(ofSize: 12, weight: .regular)
        
        title.textColor = .black
        title.font = .systemFont(ofSize: 14, weight: .medium)
        title.numberOfLines = 2
        
        price.textColor = .black
        price.font = .systemFont(ofSize: 16, weight: .heavy)
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? ShoppingItem {
            self.shoppingItem = state
            
            if let url = URL(string: state.image) {
                itemImage.kf.setImage(with: url)
            }
            
            mallName.text = state.mallName
            
            title.text = state.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
            
            let formattedPrice = Int(state.lprice)?.formatted() ?? "0"
            price.text = formattedPrice + "원"
            
            isLiked = false
        }
    }
    
    func likeShoppingItem() {
        delegate?.baseViewAction(.searchCollectionViewCellAction(.likeShoppingItem(shoppingItem)))
    }
    
    func changeLikeButtonUI() {
        if isLiked {
            likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
            likeShoppingItem()
        } else {
            likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
            cancelLikeShoppingItem()
        }
    }
    
    func setAsLikeItem() {
        isLiked = true
        changeLikeButtonUI()
    }
    
    func cancelLikeShoppingItem() {
        
        delegate?.baseViewAction(.searchCollectionViewCellAction(.cancelLikeShoppingItem(shoppingItem)))
    }
}

extension SearchResultCollectionViewCell: RoundCornerButtonDelegate {
    func roundCornerButtonTapped(_ type: RoundCornerButtonType) {
        isLiked.toggle()
        
        changeLikeButtonUI()
    }
}
