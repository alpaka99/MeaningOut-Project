//
//  MOTextField.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class MOTextField: UIView, BaseViewBuildable {
    
    weak var delegate: BaseViewDelegate?
    
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
        textField.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(inputChanged), for: .editingDidBegin)
        textField.becomeFirstResponder()
        
        divider.backgroundColor = MOColors.moGray300.color
        
        setAsOnboardingType()
    }
    
    func setAsOnboardingType() {
        checkLabel.textColor = MOColors.moOrange.color
    }
    
    func setAsSettingType() {
        checkLabel.textColor = MOColors.moBlack.color
    }
    
    func setTextFieldText(_ text: String) {
        textField.text = text
    }
    
    func fetchTextFieldText() -> String? {
        if let text = textField.text, text.isEmpty == false {
            return text
        }
        return nil
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        
    }
    
    @objc
    func inputChanged(_ sender: UITextField) {
        validateNickname(sender.text)
    }
    
    func validateNickname(_ nickName: String?) {
        do {
            let validatedNickname = try nickName.validateNickname()
            
            nicknameValidated(validatedNickname)
        } catch StringValidationError.isNil, StringValidationError.isEmpty, StringValidationError.isShort, StringValidationError.isLong {
            checkLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
        } catch StringValidationError.isUsingNumeric {
            checkLabel.text = "닉네임에 숫자는 포함할 수 없어요"
        } catch StringValidationError.isUsingSpecialLetter {
            checkLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
        } catch {
            print("Unhandled error occured")
        }
    }
    
    func nicknameValidated(_ validatedNickname: String) {
        checkLabel.text = "사용할 수 있는 닉네임이에요"
    }
}

extension String? {
    func validateNickname() throws -> String {
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
    
    func checkNil() throws -> String {
        guard let unwrappedSelf = self  else { throw StringValidationError.isNil }
        return unwrappedSelf
    }
}

extension String {
    
    func checkIsEmpty() throws {
        guard self.isEmpty == false else { throw StringValidationError.isEmpty }
    }
    
    func checkStringLength() throws {
        guard self.count >= 2 else { throw StringValidationError.isShort }
        guard self.count <= 10 else { throw StringValidationError.isLong }
    }
    
    func checkContainsSpecialLetter() throws {
        let specialLetters: [Character] = ["@", "#", "$", "%"]
        
        try specialLetters.forEach { specialLetter in
            if self.contains(where: {$0 == specialLetter}) {
                throw StringValidationError.isUsingSpecialLetter
            }
        }
    }
    
    func checkNumeric() throws {
        guard !self.contains(where: {$0.isNumber}) else { throw StringValidationError.isUsingNumeric }
    }
}


enum StringValidationError: Error {
    case isNil
    case isEmpty
    case isShort
    case isLong
    case isUsingSpecialLetter
    case isUsingNumeric
}
