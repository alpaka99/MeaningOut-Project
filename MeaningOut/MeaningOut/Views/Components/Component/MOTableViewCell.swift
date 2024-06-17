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
    let trailingButton = RoundCornerButton(
        type: .image,
        image: UIImage(systemName: ""),
        color: .clear
    )
    let trailingText = UILabel()
    
    var moCellData = MOButtonLabelData(
        leadingIconName: nil,
        leadingText:  nil,
        trailingButtonName: nil,
        trailingButtonType: .systemImage,
        trailingText: nil
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
    
    override func prepareForReuse() {
        leadingIcon.image = nil
        leadingText.text = ""
        trailingText.text = ""
        trailingButton.setImage(nil, for: .normal)
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
                .offset(-8)
            $0.verticalEdges.equalTo(contentView)
        }
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalTo(trailingText.snp.leading)
            $0.verticalEdges.equalTo(contentView)
        }
    }
    
    func configureUI() {
        if let leadingIconName = moCellData.leadingIconName {
            leadingIcon.image = UIImage(systemName: leadingIconName)
            }
        leadingIcon.tintColor = .black
        
        leadingText.text = moCellData.leadingText
        
        
        if let trailingButtonName = moCellData.trailingButtonName {
            switch moCellData.trailingButtonType {
            case .systemImage:
                trailingButton.setImage(UIImage(systemName: trailingButtonName), for: .normal)
            case .assetImage:
                trailingButton.setImage(UIImage(named: trailingButtonName), for: .normal)
                
            case .plain:
                break
            }
        }
         
            
        trailingButton.tintColor = .black
        trailingButton.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        
        
        trailingText.text = moCellData.trailingText
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? MOButtonLabelData {
            self.moCellData = state
        }
    }
    
    @objc
    func trailingButtonTapped() {
        delegate?.baseViewAction(.moButtonLabelAction(.trailingButtonTapped(moCellData)))
    }
}
