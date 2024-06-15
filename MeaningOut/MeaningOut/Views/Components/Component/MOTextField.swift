//
//  MOTextField.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class MOTextField: UIView, BaseViewBuildable {
    weak var delegate: BaseViewBuildableDelegate?
    
    let textField = UITextField()
    let divider = UIView()
    let checkLabel = UILabel()
    
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
        self.addSubview(textField)
        self.addSubview(divider)
        self.addSubview(checkLabel)
    }
    
    func configureLayout() {
        textField.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
                .offset(16)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(1)
        }
        
        checkLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
                .offset(16)
            $0.horizontalEdges.bottom.equalTo(self)
        }
        
    }
    
    func configureUI() {
        textField.placeholder = "닉네임을 입력해주세요"
        
        divider.backgroundColor = MOColors.moGray300.color
        
        checkLabel.text = "닉네임에 @는 포함할 수 없어요"
        checkLabel.textColor = MOColors.moOrange.color
    }
    
    func configureData() {
        
    }
}
