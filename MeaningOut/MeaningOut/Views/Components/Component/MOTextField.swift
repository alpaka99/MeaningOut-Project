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
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? ProfileSettingViewControllerState {
            print(state)
            textField.text = state.userName
        }
    }
    
    @objc
    func inputChanged(_ sender: UITextField) {
        validateNickname(sender.text)
    }
    
    @discardableResult
    func validateNickname(_ nickName: String?) -> String {
        do {
            let validatedNickname = try nickName.validateNickname()
            
            return nicknameValidated(validatedNickname)
        } catch StringValidationError.isNil, StringValidationError.isEmpty, StringValidationError.isShort, StringValidationError.isLong {
            delegate?.baseViewAction(.moTextFieldAction(.textFieldTextChanged(false)))
            checkLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
        } catch StringValidationError.isUsingNumeric {
            delegate?.baseViewAction(.moTextFieldAction(.textFieldTextChanged(false)))
            checkLabel.text = "닉네임에 숫자는 포함할 수 없어요"
        } catch StringValidationError.isUsingSpecialLetter {
            delegate?.baseViewAction(.moTextFieldAction(.textFieldTextChanged(false)))
            checkLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
        } catch {
            delegate?.baseViewAction(.moTextFieldAction(.textFieldTextChanged(false)))
            print("Unhandled error occured")
        }
        return ""
    }
    
    @discardableResult
    func nicknameValidated(_ validatedNickname: String) -> String {
        delegate?.baseViewAction(.moTextFieldAction(.textFieldTextChanged(true)))
        checkLabel.text = "사용할 수 있는 닉네임이에요"
        return validatedNickname
    }
    
    func triggerAction() {
        let validatedNickname = validateNickname(textField.text)
        delegate?.baseViewAction(.moTextFieldAction(.sendTextFieldText(validatedNickname)))
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
