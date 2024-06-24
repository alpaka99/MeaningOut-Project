//
//  Constants.swift
//  MeaningOut
//
//  Created by user on 6/13/24.
//

import UIKit

enum MOColors: CaseIterable {
    case moOrange
    case moBlack
    case moGray100
    case moGray200
    case moGray300
    case moWhite
    
    
    var color: UIColor {
        switch self {
        case .moOrange:
            return UIColor.hexToColor("#EF8947") ?? .clear
        case .moBlack:
            return UIColor.hexToColor("#000000") ?? .clear
        case .moGray100:
            return UIColor.hexToColor("#4C4C4C") ?? .clear
        case .moGray200:
            return UIColor.hexToColor("#828282") ?? .clear
        case .moGray300:
            return UIColor.hexToColor("#CDCDCD") ?? .clear
        case .moWhite:
            return UIColor.hexToColor("#FFFFFF") ?? .clear
        }
    }
}


struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}


enum ProfileImage: String, CaseIterable, Codable {
    case profile_0
    case profile_1
    case profile_2
    case profile_3
    case profile_4
    case profile_5
    case profile_6
    case profile_7
    case profile_8
    case profile_9
    case profile_10
    case profile_11
    
    static var randomProfileImage: ProfileImage {
        if let randomProfileImage = Self.allCases.randomElement() {
            return randomProfileImage
        }
        return .profile_0
    }
}


enum SortOptions: String, CaseIterable, Codable {
    case simularity = "sim"
    case date = "date"
    case ascendingPrice = "asc"
    case descendingPrice = "dsc"
    
    var buttonTitle: String {
        switch self {
        case .simularity:
            return "정확도"
        case .date:
            return "날짜순"
        case .descendingPrice:
            return "가격높은순"
        case .ascendingPrice:
            return "가격낮은순"
        }
    }
}

enum SettingOptions: CaseIterable {
    case liked
    case qna
    case oneOnOneQuestion
    case notification
    case quit
    
    var trailingImageName: String? {
        switch self {
        case .liked:
            return "like_selected"
        default:
            return nil
        }
    }
    
    var leadingTitle: String? {
        switch self {
        case .liked:
            return "나의 장바구니 목록"
        case .qna:
            return "자주 묻는 질문"
        case .oneOnOneQuestion:
            return "1:1 문의"
        case .notification:
            return "알림 설정"
        case .quit:
            return "탈퇴하기"
        }
    }
    
    func getTrailingText(_ count: Int) -> String? {
        switch self {
        case .liked:
            return "\(count)개의 상품"
        default:
            return nil
        }
    }
}


struct JSONHelper {
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
}

struct DateHelper {
    static let dateFormatter = DateFormatter()
    static let settingHeaederCellDateFormat = "yyyy.MM.dd 가입"
}

enum TabBarItemProperty {
    case mainView
    case settingView
    
    var systemName: String {
        switch self {
        case .mainView:
            return "magnifyingglass"
        case .settingView:
            return "person"
        }
    }
    
    var title: String {
        switch self {
        case .mainView:
            return "검색"
        case .settingView:
            return "설정"
        }
    }
}

struct SettingViewConstants {
    // SettingViewController Constants
    static let alertControllerTitle = "탈퇴하기"
    static let alertControllerMessage = "탈퇴를 하면 테이터가 모두 초기화 됩니다. 탈퇴 하시겠습니까?"
    static let cancelButtonTitle = "취소"
    static let conformButtonTitle = "확인"
    
    // SettingView Constants
    static let numberOfSection: Int = 2
    static let numberOfHeaderCell: Int = 1
    static let settingCellHeight: CGFloat = 44
    
    static let navigationTitle = "SETTING"
    
}

struct ReplaceStringConstants {
    // DetailSearchViewController Constants
    static let boldHTMLOpenTag = "<b>"
    static let boldHTMLCloseTag = "</b>"
}

struct SearchResult {
    static let totalResultLabelText = "개의 검색결과"
}

struct ImageName {
    static let chevronRight = "chevron.right"
    static let selectedLikeButtonImage = "like_selected"
    static let unSelecteLikeButtonImage = "like_unselected"
    static let empty = "empty"
    
    static let clock = "clock"
    static let xmark = "xmark"
    static let lauch = "launch"
    static let cameraFilled = "camera.fill"
}

enum ParameterKey: CaseIterable {
    static let query = "query"
    static let display = "display"
    static let start = "start"
    static let sort = "sort"
}


struct PageNationConstants {
    static let start: Int = 1
    static let pageAmount: Int = 30
}


struct SearchResultConstants {
    static let defaultPrice = "0"
    static let won = "원"
}


struct MainViewConstants {
    // MainViewController Constants
    static let navigationTitleSufix = "님의 MeaningOut"
    
    // MainView Constants
    static let searchBarPlaceholder = "브랜드, 상품 등을 입력하세요"
    
    static let emptyLabelText = "최근 검색어가 없어요"
    static let headerViewLeadingText = "최근 기록"
}

struct MOTextFieldConstants {
    static let placeholder = "닉네임을 입력해주세요 :)"
}

struct StringValidationConstants {
    static let lengthError = "2글자 이상 10글자 미만으로 설정해주세요"
    static let containsNumericError = "닉네임에 숫자는 포함할 수 없어요"
    static let containsSpecialLetterError = "닉네임에 @, #, $, %는 포함할 수 없어요"
    static let unHandledError = "Unhandled error occured"
    static let avaliableNickname = "사용할 수 있는 닉네임이에요"
}

enum SpecialLetterConstants:Character, CaseIterable {
    case at = "@"
    case sharp = "#"
    case dollar = "$"
    case percent = "%"
    
    static var allStringCases: [Character] {
        var allRawValue: [Character] = []
        
        Self.allCases.forEach { specialString in
            allRawValue.append(specialString.rawValue)
        }
        return allRawValue
    }
}

struct MOButtonLabelConstants {
    static let eraseAllTitle = "전체 삭제"
}


struct LogoViewConstants {
    static let startButtonTitle = "시작하기"
    static let logoTitle = "MeaningOut"
    static let creatorName = "고석환"
}


struct ProfileSettingViewConstants {
    static let saveButtonTitle = "저장"
    static let completeButtonTitle = "완료"
    
    static let onBoardingTitle = "PROFILE SETTING"
    static let settingTitle = "EDIT PROFILE"
}
