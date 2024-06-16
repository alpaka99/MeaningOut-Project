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
    let trailingButton = RoundCornerButton(type: .image, image: UIImage(systemName: "xmark"), color: .clear)
    let trailingText = UILabel()
    
    var moCellData = MOButtonLabelData(
        leadingIconName: "",
        leadingText: "",
        trailingButtonName: "", 
        trailingButtonType: .image,
        trailingText: ""
    ) {
        didSet {
            configureUI()
        }
    }
    
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
        contentView.addSubview(trailingButton)
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
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalTo(trailingText.snp.leading)
                .offset(-8)
            $0.verticalEdges.equalTo(contentView)
        }
    }
    
    func configureUI() {
        leadingIcon.image = UIImage(systemName: moCellData.leadingIconName)
        leadingIcon.tintColor = .black
        
        leadingText.text = moCellData.leadingText
        
        trailingButton.tintColor = .black
        trailingButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        
        trailingText.text = moCellData.trailingText
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? MOButtonLabelData {
            self.moCellData = state
        }
    }
    
    @objc
    func deleteButtonTapped() {
        print(#function)
        delegate?.baseViewAction(.moButtonLabelAction(.deleteButtonTapped(moCellData)))
    }
}
