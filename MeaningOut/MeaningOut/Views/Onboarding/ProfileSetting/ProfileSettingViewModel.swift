//
//  ProfileSettingViewModel.swift
//  MeaningOut
//
//  Created by user on 7/9/24.
//

import Foundation

final class ProfileSettingViewModel {
    var inputSelectedImage = Observable(ProfileImage.randomProfileImage)
    var inputUserName: Observable<String?> = Observable("")
    var inputProfileSettingViewType = Observable(ProfileSettingViewType.onBoarding)
    var inputProfileImageTapped: Observable<Void?> = Observable(())
    var inputCompleteButtonTapped: Observable<Void?> = Observable(())
    
    var outputValidated = Observable(false)
    var outputCheckLabelText: Observable<String?> = Observable("")
    
    init() {
        inputUserName.bind { [weak self] _ in
            self?.validateNickname()
        }
    }
    
    private func validateNickname() {
        do {
            let validatedNickname = try self.inputUserName.value.validateNickname()
            
            outputCheckLabelText.value = "사용 가능한 닉네임입니다 :)"
            outputValidated.value = true
        } catch StringValidationError.isNil, StringValidationError.isEmpty, StringValidationError.isShort, StringValidationError.isLong {
            outputCheckLabelText.value = StringValidationConstants.lengthError
            outputValidated.value = false
        } catch StringValidationError.isUsingNumeric {
            outputCheckLabelText.value = StringValidationConstants.containsNumericError
            outputValidated.value = false
        } catch StringValidationError.isUsingSpecialLetter {
            outputCheckLabelText.value = StringValidationConstants.containsSpecialLetterError
            outputValidated.value = false
        } catch {
            print(StringValidationConstants.unHandledError)
            outputValidated.value = false
        }
    }
}
