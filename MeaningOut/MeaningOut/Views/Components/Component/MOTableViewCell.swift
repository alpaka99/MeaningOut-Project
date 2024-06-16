//
//  MOTableViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class MOTableViewCell: UITableViewCell, BaseViewBuildable {
    var delegate: BaseViewDelegate?
    
    let leadingIcon = UIImageView()
    let leadingText = UILabel()
    let trailingIcon = UIImageView()
    let trailingText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(leadingIcon)
        contentView.addSubview(leadingText)
        contentView.addSubview(trailingIcon)
        contentView.addSubview(trailingText)
    }
    
    func configureLayout() {
        leadingIcon.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(contentView)
                .inset(8)
        }
        
        leadingText.snp.makeConstraints {
            $0.leading.equalTo(leadingIcon.snp.trailing)
                .offset(8)
            $0.verticalEdges.equalTo(contentView)
        }
        
        trailingText.snp.makeConstraints {
            $0.trailing.equalTo(contentView)
            $0.verticalEdges.equalTo(contentView)
        }
        
        trailingIcon.snp.makeConstraints {
            $0.trailing.equalTo(trailingText.snp.leading)
                .offset(-8)
            $0.verticalEdges.equalTo(contentView)
                .inset(8)
        }
    }
    
    func configureUI() {
        
    }
    
    
    func configureData(_ data: MOCellData) {
        leadingIcon.image = UIImage(systemName: data.leadingIconName)
        leadingIcon.tintColor = .black
        
        leadingText.text = data.leadingText
        
        trailingIcon.image = UIImage(systemName: data.trailingIconName)
        trailingIcon.tintColor = .black
        
        trailingText.text = data.trailingText
    }
}

struct MOCellData {
    let leadingIconName: String
    let leadingText: String
    let trailingIconName: String
    let trailingText: String
}
