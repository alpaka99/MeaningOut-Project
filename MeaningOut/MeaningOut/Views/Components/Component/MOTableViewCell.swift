//
//  MOTableViewCell.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class MOTableViewCell: BaseTableViewCell {
    private let leadingIcon = UIImageView()
    private let leadingText = UILabel()
    private(set) var trailingButton = RoundCornerButton(
        type: .image,
        image: nil,
        color: .clear
    )
    private let trailingText = UILabel()
    
    private var moCellData = MOButtonLabelData(
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
        leadingText.text = String.emptyString
        trailingText.text = String.emptyString
        trailingButton.setImage(
            nil,
            for: .normal
        )
    }
    
    override internal func configureHierarchy() {
        contentView.addSubview(leadingIcon)
        contentView.addSubview(leadingText)
        contentView.addSubview(trailingButton)
        contentView.addSubview(trailingText)
    }
    
    override internal func configureLayout() {
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
    
    override internal func configureUI() {
        if let leadingIconName = moCellData.leadingIconName {
            leadingIcon.image = UIImage(systemName: leadingIconName)
            }
        leadingIcon.tintColor = .black
        
        leadingText.text = moCellData.leadingText
        
        
        if let trailingButtonName = moCellData.trailingButtonName {
            switch moCellData.trailingButtonType {
            case .systemImage:
                trailingButton.setImage(
                    UIImage(systemName: trailingButtonName),
                    for: .normal
                )
            case .assetImage:
                trailingButton.setImage(
                    UIImage(named: trailingButtonName),
                    for: .normal
                )
            case .plain:
                break
            }
        }
         
            
        trailingButton.tintColor = .black
        trailingButton.addTarget(
            self,
            action: #selector(trailingButtonTapped),
            for: .touchUpInside
        )
        
        trailingText.text = moCellData.trailingText
    }
    
    internal func configureData(_ data: MOButtonLabelData) {
        self.moCellData = data
    }
    
    @objc
    private func trailingButtonTapped() {
//        delegate?.baseViewAction(.moButtonLabelAction(.trailingButtonTapped(moCellData)))
    }
}
