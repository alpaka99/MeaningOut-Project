//
//  SearchResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import Kingfisher
import SnapKit

final class SearchResultCollectionViewCell: BaseCollectionViewCell {
    private let itemImage = UIImageView()
    private let likeButton = RoundCornerButton(
        type: .image,
        image: UIImage(named: ImageName.unSelecteLikeButtonImage),
        color: MOColors.moGray100.color.withAlphaComponent(0.3)
    )
    private let mallName = UILabel()
    private let title = UILabel()
    private let price = UILabel()
    private var isLiked = false
    
    private var shoppingItem = ShoppingItem.dummyShoppingItem()
    
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
        likeButton.setImage(UIImage(
            named: ImageName.unSelecteLikeButtonImage),
                            for: .normal
        )
        itemImage.image = nil
    }
    
    override internal func configureHierarchy() {
        contentView.addSubview(itemImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallName)
        contentView.addSubview(title)
        contentView.addSubview(price)
    }
    
    override internal func configureLayout() {
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
    
    override internal func configureUI() {
        itemImage.layer.cornerRadius = 8
        itemImage.clipsToBounds = true
        
        if isLiked == false {
            likeButton.setImage(
                UIImage(named: ImageName.unSelecteLikeButtonImage),
                for: .normal)
        }
        likeButton.backgroundColor = MOColors.moGray300.color.withAlphaComponent(0.5)
        likeButton.tintColor = .white
        likeButton.layer.cornerRadius = 8
//        likeButton.delegate = self
        
        mallName.textColor = MOColors.moGray300.color
        mallName.font = .systemFont(ofSize: 12, weight: .regular)
        
        title.textColor = .black
        title.font = .systemFont(ofSize: 14, weight: .medium)
        title.numberOfLines = 2
        
        price.textColor = .black
        price.font = .systemFont(ofSize: 16, weight: .heavy)
    }
    
//    override internal func configureData(_ state: any BaseViewControllerState) {
//        if let state = state as? ShoppingItem {
//            self.shoppingItem = state
//            
//            mallName.text = state.mallName
//            
//            title.text = state.title.replacingOccurrences(
//                of: ReplaceStringConstants.boldHTMLOpenTag,
//                with: String.emptyString
//            ).replacingOccurrences(
//                of: ReplaceStringConstants.boldHTMLCloseTag,
//                with: String.emptyString
//            )
//            
//            let formattedPrice = Int(state.lprice)?.formatted() ?? SearchResultConstants.defaultPrice
//            price.text = formattedPrice + SearchResultConstants.won
//            
//            isLiked = false
//        }
//    }
    
    internal func setImage(with image: UIImage) {
        self.itemImage.image = image
    }
    
    private func likeShoppingItem() {
//        delegate?.baseViewAction(.searchCollectionViewCellAction(.likeShoppingItem(shoppingItem)))
    }
    
    private func changeLikeButtonUI() {
        if isLiked {
            likeButton.setImage(UIImage(
                named: ImageName.selectedLikeButtonImage),
                                for: .normal
            )
            likeShoppingItem()
        } else {
            likeButton.setImage(UIImage(
                named: ImageName.unSelecteLikeButtonImage),
                                for: .normal
            )
            cancelLikeShoppingItem()
        }
    }
    
    internal func setAsLikeItem() {
        isLiked = true
        changeLikeButtonUI()
    }
    
    private func cancelLikeShoppingItem() {
//        delegate?.baseViewAction(.searchCollectionViewCellAction(.cancelLikeShoppingItem(shoppingItem)))
    }
    
    internal func toggleIsLiked() {
        switch isLiked {
        case true:
            isLiked = false
        case false:
            isLiked = true
        }
    }
}

extension SearchResultCollectionViewCell: RoundCornerButtonDelegate {
    internal func roundCornerButtonTapped(_ type: RoundCornerButtonType) {
        isLiked.toggle()
        
        changeLikeButtonUI()
    }
}
