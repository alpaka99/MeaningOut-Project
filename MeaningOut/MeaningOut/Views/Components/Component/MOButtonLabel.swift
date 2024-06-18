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
        leadingIconName: nil,
        leadingText: nil,
        trailingButtonName: nil,
        trailingButtonType: .plain,
        trailingText: nil
    ) {
        didSet {
            configureUI()
        }
    }
    
    let leadingIcon = UIImageView()
    let leadingText = UILabel()
    let trailingButton = RoundCornerButton(
        type: .plain,
        title: MOButtonLabelConstants.eraseAllTitle,
        color: .clear
    )
    let trailingText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    convenience init(leadingText: String, trailingButtonName: String, trailingText: String, buttonType: MOButtonLabelTrailingButtonType) {
        self.init(frame: .zero)
        moButtonLabelData.leadingText = leadingText
        moButtonLabelData.trailingButtonName = trailingButtonName
        moButtonLabelData.trailingText = trailingText
        moButtonLabelData.trailingButtonType = buttonType
    }
    
    convenience init(leadingText: String) {
        self.init(frame: .zero)
        moButtonLabelData.leadingText = leadingText
    }
    
    convenience init(leadingText: String, trailingText: String) {
        self.init(frame: .zero)
        moButtonLabelData.leadingText = leadingText
        moButtonLabelData.trailingText = trailingText
    }
    
    convenience init(leadingIconName: String, leadingText: String, trailingButtonName: String, buttonType: MOButtonLabelTrailingButtonType) {
        self.init(frame: .zero)
        moButtonLabelData.leadingIconName = leadingIconName
        moButtonLabelData.leadingText = leadingText
        moButtonLabelData.trailingButtonName = trailingButtonName
        moButtonLabelData.trailingButtonType = buttonType
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
        if let leadingIconName = moButtonLabelData.leadingIconName {
            leadingIcon.image = UIImage(systemName: leadingIconName)
        }
        leadingIcon.tintColor = .black
        
        leadingText.text = moButtonLabelData.leadingText
        
        trailingButton.tintColor = .black
        trailingButton.addTarget(
            self,
            action: #selector(eraseAllButtonTapped),
            for: .touchUpInside
        )
        
        trailingText.text = moButtonLabelData.trailingText
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? MOButtonLabelData {
            self.moButtonLabelData = state
        }
    }
    
    func setTrailingButtonColor(with color: UIColor) {
        print(#function)
        trailingButton.tintColor = color
    }
    
    @objc
    func eraseAllButtonTapped() {
        delegate?.baseViewAction(.moButtonLabelAction(.eraseAllHistoryButtonTapped))
    }
}
