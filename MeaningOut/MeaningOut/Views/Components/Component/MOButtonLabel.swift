//
//  MOButtonLabel.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

import SnapKit

final class MOButtonLabel: UIView, BaseViewBuildable {
    var delegate: (any BaseViewDelegate)?
    
    var moButtonLabelData: MOButtonLabelData = MOButtonLabelData(
        leadingIconName: "",
        leadingText: "최근 기록",
        trailingButtonName: "전체 삭제",
        trailingButtonType: .plain,
        trailingText: ""
    ) {
        didSet {
            configureUI()
        }
    }
    
    let leadingIcon = UIImageView()
    let leadingText = UILabel()
    let trailingButton = RoundCornerButton(
        type: .plain,
        title: "전체 삭제",
        color: .clear
    )
    let trailingText = UILabel()
    
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
        self.addSubview(leadingIcon)
        self.addSubview(leadingText)
        self.addSubview(trailingButton)
        self.addSubview(trailingText)
    }
    
    func configureLayout() {
        leadingIcon.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(self)
                .inset(8)
        }
        
        leadingText.snp.makeConstraints {
            $0.leading.equalTo(leadingIcon.snp.trailing)
                .offset(8)
            $0.verticalEdges.equalTo(self)
        }
        
        trailingText.snp.makeConstraints {
            $0.trailing.equalTo(self)
            $0.verticalEdges.equalTo(self)
        }
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalTo(trailingText.snp.leading)
                .offset(-8)
            $0.verticalEdges.equalTo(self)
        }
    }
    
    func configureUI() {
        leadingIcon.image = UIImage(systemName: moButtonLabelData.leadingIconName)
        leadingIcon.tintColor = .black
        
        leadingText.text = moButtonLabelData.leadingText
        
        trailingButton.tintColor = .black
        trailingButton.addTarget(self, action: #selector(eraseAllButtonTapped), for: .touchUpInside)
        
        trailingText.text = moButtonLabelData.trailingText
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? MOButtonLabelData {
            self.moButtonLabelData = state
        }
    }
    
    @objc
    func eraseAllButtonTapped() {
        delegate?.baseViewAction(.moButtonLabelAction(.eraseAllHistoryButtonTapped))
    }
}
