//
//  MOTextField.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class MOTextField: BaseView {
    
    private(set) var textField = UITextField()
    private let divider = UIView()
    private(set) var checkLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func configureHierarchy() {
        self.addSubview(textField)
        self.addSubview(divider)
        self.addSubview(checkLabel)
    }
    
    override internal func configureLayout() {
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
    
    override internal func configureUI() {
        textField.placeholder = MOTextFieldConstants.placeholder
        textField.becomeFirstResponder()
        
        divider.backgroundColor = MOColors.moGray300.color
        
        checkLabel.font = UIFont.systemFont(
            ofSize: 12,
            weight: .medium
        )
        
        setAsOnboardingType()
    }
    
    // MARK: 추후에 하나의 메서드로 합치기
    internal func setAsOnboardingType() {
        checkLabel.textColor = MOColors.moOrange.color
    }
    
    internal func setAsSettingType() {
        checkLabel.textColor = MOColors.moBlack.color
    }
    
//    override internal func configureData(_ state: any BaseViewControllerState) {
//        if let state = state as? ProfileSettingViewControllerState {
//            textField.text = state.userName
//        }
//    }
}

extension String? {
    internal func validateNickname() throws -> String {
        do {
            let unWrappedNickName = try self.checkNil()
            
            try unWrappedNickName.checkIsEmpty()
            try unWrappedNickName.checkStringLength()
            try unWrappedNickName.checkContainsSpecialLetter()
            try unWrappedNickName.checkNumeric()
            
            return unWrappedNickName
        } catch {
            throw error
        }
    }
    
    private func checkNil() throws -> String {
        guard let unwrappedSelf = self  else { throw StringValidationError.isNil }
        return unwrappedSelf
    }
}

extension String {
    internal func checkIsEmpty() throws {
        guard self.isEmpty == false else { throw StringValidationError.isEmpty }
    }
    
    internal func checkStringLength() throws {
        guard self.count >= 2 else { throw StringValidationError.isShort }
        guard self.count <= 10 else { throw StringValidationError.isLong }
    }
    
    internal func checkContainsSpecialLetter() throws {
        let specialLetters: [Character] = SpecialLetterConstants.allStringCases
        
        try specialLetters.forEach { specialLetter in
            if self.contains(where: {$0 == specialLetter}) {
                throw StringValidationError.isUsingSpecialLetter
            }
        }
    }
    
    internal func checkNumeric() throws {
        guard !self.contains(where: {$0.isNumber}) else { throw StringValidationError.isUsingNumeric }
    }
}
